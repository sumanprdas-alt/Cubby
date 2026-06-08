# Cubby — AI Architecture

> Step 2 deliverable.

---

## AI strategy

Single provider: **Claude API (Anthropic)**. One API for all AI capabilities — document vision, classification, entity extraction, and conversational assistant. No separate OCR service.

Model selection:
- **Sonnet** — all classification, extraction, and standard assistant queries (fast, cost-effective)
- **Haiku** — simple re-classification retries, query parsing (cheapest)
- **Opus** — reserved for complex multi-document reasoning if needed (not MVP)

---

## Orchestrator: InboxOrchestrator

Single API call per document. Claude Vision (multimodal) reads the image and returns structured JSON.

### System prompt (classification)

```
You are Cubby, a family document assistant for families in Dubai/UAE.

You will receive either an IMAGE of a document OR TEXT (e.g. a forwarded WhatsApp message, email, or note).

Determine if the input is:
A) A document (passport, visa, prescription, etc.) → classify it
B) An event/appointment/meeting/deadline → extract the event
C) Both (e.g. a booking confirmation is both a document and an event)

Return ONLY valid JSON:

{
  "input_type": "document | event | both",
  "document_type": "passport | emirates_id | visa | health_card | prescription | lab_report | insurance_policy | school_report | tenancy_contract | vehicle_registration | vaccination_record | booking_confirmation | certificate | bill | receipt | pet_vaccination | pet_medical | event | other",
  "confidence": "high | medium | low",
  "title": "Short descriptive title (e.g. 'Arjun Sharma - UAE Visa' or 'Parent-teacher meeting — Grade 4')",
  "extracted_fields": {
    // Key-value pairs of everything you can read or detect:
    // name, id_number, expiry_date, issue_date, amount, doctor_name,
    // medications, school_name, grade, airline, hotel,
    // event_time, event_location, event_organizer, etc.
  },
  "suggested_person": "Name of the person this belongs to, if identifiable. null if unclear.",
  "expiry_date": "YYYY-MM-DD if found, null otherwise",
  "event_date": "YYYY-MM-DD if this is an event/appointment, null otherwise",
  "event_time": "HH:MM if found, null otherwise",
  "remind_before_days": 1,
  "summary": "One sentence describing what this is"
}

Rules:
- Extract ALL visible text fields. Be thorough.
- If handwriting is unclear, make best guess and set confidence to "medium".
- If document is unreadable, set confidence to "low" and type to "other".
- For text input: detect dates, times, locations, and event-like language ("meeting", "appointment", "due date", "deadline", "reminder").
- Dates in DD/MM/YYYY format should be converted to YYYY-MM-DD.
- Do not invent information. Only extract what you can see or read.
- If you cannot determine who the document/event belongs to, set suggested_person to null — do not guess.
```

### Response handling

```dart
// Pseudocode
final response = await claudeApi.createMessage(
  model: 'claude-sonnet-4-20250514',
  messages: [
    { role: 'user', content: [
      { type: 'image', source: { type: 'base64', data: imageBase64 } },
      { type: 'text', text: 'Classify and extract data from this document.' }
    ]}
  ],
  system: classificationSystemPrompt,
  maxTokens: 1000,
);

final json = parseJson(response.content.text);
final item = FamilyItem.fromAiResponse(json);
// Match suggested_person to family members via fuzzy name match
// Create FamilyItem with status: pending
```

### Cost per classification
- Image input: ~1000 tokens (base64 image)
- Text output: ~200-500 tokens (JSON response)
- Cost: ~$0.005-0.01 per document (Sonnet)
- At 15 docs/family/month, 1000 families: ~$75-150/month

---

## Orchestrator: AssistantOrchestrator

### Pipeline
```
User query
  → SearchOrchestrator returns top 10 results
  → Prune to top 5 most relevant (by FTS5 rank)
  → Build context: query + family member names + top 5 item summaries
  → Send to Claude
  → Parse response with citations
  → Return to UI
```

### System prompt (assistant)

```
You are Cubby Assistant, a helpful family document assistant.

You have access to the following family data:

Family members: {memberList}

Relevant documents:
{top5Items — each with: id, title, type, extracted_fields, linked_members, dates}

Answer the user's question using ONLY the provided data.
- Cite specific documents by their title.
- If the answer isn't in the data, say so. Never invent facts.
- Be concise and direct.
- If dates are involved, calculate relative time (e.g., "expires in 47 days").
- If multiple items are relevant, list them.
```

### Cost per query
- Input: ~500-1500 tokens (context + query)
- Output: ~100-300 tokens (answer)
- Cost: ~$0.003-0.008 per query (Sonnet)
- At 20 queries/month/family, 1000 families: ~$60-160/month

---

## Orchestrator: FeedbackOrchestrator

When user corrects a classification:
1. Store correction in `user_corrections` table (original vs corrected)
2. Corrections accumulate as labeled training data
3. Future: use corrections to refine system prompts or fine-tune a smaller model
4. Track correction rate per document_type — if type X is corrected > 20% of the time, the prompt needs tuning

---

## Orchestrator: DuplicateDetectionOrchestrator

On item confirmation:
1. Generate perceptual hash of the document image (pHash)
2. Compare against hashes of existing confirmed items in the same family
3. If hamming distance < threshold: flag as potential duplicate
4. Show user: "This looks similar to [existing item]. Is it a duplicate?"

No API call needed. Runs locally.

---

## AI eval framework

| Capability | Metric | Target | Eval dataset |
|-----------|--------|--------|-------------|
| Document classification | F1 score per type | > 85% (MVP), > 90% (post-beta) | 200+ documents across all Dubai types |
| Field extraction | Field-level accuracy | > 80% (MVP) | Same 200+ documents with ground truth fields |
| Person matching | Accuracy | > 85% | 100+ items with known person assignments |
| Reminder generation | Precision | > 95% (no false reminders) | 50+ items with dates |
| Assistant retrieval | Answer in top 5 results | > 75% | 100+ question-answer pairs |
| Assistant accuracy | Factual correctness | > 90% (MVP), > 95% (post-beta) | Same 100+ QA pairs |
| Hallucination | False claims rate | < 5% (MVP), < 2% (post-beta) | Same 100+ QA pairs |
| Duplicate detection | Precision / recall | > 80% / > 70% | 50+ duplicate/non-duplicate pairs |

### Eval workflow
1. Create golden dataset (manually labeled documents + expected outputs)
2. Run AI pipeline on dataset → compare outputs to expected
3. Calculate metrics
4. RED: metrics below target → tune prompts
5. GREEN: metrics meet target → ship
6. On every prompt change: re-run full eval suite. No regressions.

---

## Cost optimization strategies

1. **Cache system prompts** — Anthropic prompt caching reduces repeat input costs
2. **Batch where possible** — Gallery multi-select: process sequentially but reuse connection
3. **Haiku for simple tasks** — Query parsing, duplicate check heuristics
4. **Rate limit free tier** — 20 assistant queries/month caps AI spend per free user
5. **Local-first classification rules** — Known document formats (Emirates ID front/back) can be pre-classified by local heuristics before hitting API
6. **Truncate context** — Send top 5 results to assistant, not top 20

---

*See also: search-architecture.md, system-architecture.md*
