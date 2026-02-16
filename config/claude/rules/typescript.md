---
paths:
  - "**/*.{ts,tsx}"
---

# TypeScript

- Prefer Array/iterable methods instead of declaring an array and pushing onto it
- Prefer flatMap instead of filter + map to save iterations
- Prefer types to interfaces where possible
- Export types for all exported functions
- ALWAYS use named exports instead of default exports
- NO NEW barrel files
- Derive types from other types, schemas, etc as much as possible
- Prefer named types to anonymous types
- Avoid Enums and use string unions unless absolutely necessary
- Top level function declarations SHOULD ALWAYS use the function keyword
- Place utility functions at the end of the file and rely on hoisting
- Avoid JSDocs when there are typescript types. Add comments to TS types instead
- Avoid return type annotations where possible
