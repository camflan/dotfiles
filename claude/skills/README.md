# Custom Claude Skills

Personal skills that are available across all projects.

## Structure

Each skill should have its own directory:

```
claude/skills/skill-name/
└── SKILL.md (required)
```

## Skill File Format

```yaml
---
name: skill-name
description: Brief description and when to use it
---

# Skill Name

Instructions for Claude…
```

## Best Practices

- Use kebab-case for directory names
- Keep SKILL.md under 500 lines
- Match directory name to skill name
- Description should explain what and when (max 1024 chars)
