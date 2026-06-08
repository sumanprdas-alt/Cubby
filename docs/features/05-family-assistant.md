# Feature Spec: Family Assistant

> Module 5. Natural language queries across all family data.

---

## Goals
- Let users ask questions in plain English and get accurate, cited answers
- Surface information families didn't know they had (proactive insights)
- Make retrieval conversational, not navigational

## User stories
- As a user, I want to ask "When does Arjun's visa expire?" and get a direct answer
- As a user, I want to ask "Show me all prescriptions from last month" and get a filtered list
- As a user, I want the assistant to cite which document its answer came from
- As a user offline, I want search results even without an AI answer
- As a user, I want example queries so I know what to ask

## User flow
**Ask a question:** Assistant tab → chat-style screen → text input at bottom → type query → send → typing indicator → AI answer appears with citations → tap citation to see source document

**Example queries:** When chat is empty, show 5 tappable example queries:
- "When does our visa expire?"
- "Show me Buddy's vaccination records"
- "What prescriptions is Ria taking?"
- "Which documents expire in the next 3 months?"
- "What insurance policies do we have?"

**Follow-up:** User can ask follow-up questions in same conversation. Context is maintained within session (not persisted across sessions for MVP).

**Offline:** Query submitted → local search results displayed as a list → banner: "AI answers available when online"

## Edge cases
- Query with no matching results → "I don't have any information about that. Try adding more documents to your vault."
- Query about a person not in the family → "I don't see a family member named [X]. Did you mean [closest match]?"
- Ambiguous query ("show me everything") → return most recent 10 items across all members
- Free tier user exceeds 20 queries/month → "You've used your free assistant queries this month. Upgrade for unlimited." → show local search results as fallback
- AI returns an answer not supported by any document → this should never happen (prompt instructs "only use provided data") but if it does → no citations shown → user can flag as incorrect
- Very long answer → truncate at 300 words with "See more" expander

## Acceptance criteria
- [ ] Chat-style UI with user messages right-aligned, assistant left-aligned
- [ ] Typing indicator while waiting for AI response
- [ ] AI answers cite specific FamilyItems by title
- [ ] Tapping a citation navigates to item detail screen
- [ ] 5 example queries shown when chat is empty, tappable
- [ ] Follow-up questions work within same session
- [ ] Offline: shows local search results with "AI unavailable" banner
- [ ] Free tier: 20 queries/month limit enforced, counter shown
- [ ] Response time < 5 seconds (end-to-end)
- [ ] AI never invents information not in the provided documents

## Analytics events
- `assistant_query` { query_length, had_results }
- `assistant_response` { duration_ms, citations_count }
- `assistant_citation_tapped` { document_type }
- `assistant_example_tapped` { example_text }
- `assistant_rate_limited` { queries_used, queries_limit }
- `assistant_offline_fallback`

## Permissions requirements
- All family members can use assistant
- Results filtered by user's role visibility

## AI requirements
- AssistantOrchestrator: search (top 5) → Claude API with system prompt → cited answer
- System prompt enforces: only answer from provided data, cite sources, never hallucinate
- Eval: answer accuracy > 90%, hallucination rate < 5% (MVP), < 2% (post-beta)

## Success metrics
| Metric | Target |
|--------|--------|
| Assistant queries per family/week | ≥ 3 (month 3), ≥ 8 (month 6) |
| Answer accuracy (eval) | > 90% |
| Citation tap rate | > 30% (users verify answers) |
| Rate limit hit rate (free) | < 20% of free users/month |
