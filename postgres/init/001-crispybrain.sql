CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS memories (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    source TEXT NOT NULL,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,

    tags TEXT[] NOT NULL DEFAULT '{}',
    metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb,

    embedding vector(1536)
);

CREATE INDEX IF NOT EXISTS idx_memories_created_at
    ON memories (created_at DESC);

CREATE INDEX IF NOT EXISTS idx_memories_source
    ON memories (source);

CREATE INDEX IF NOT EXISTS idx_memories_category
    ON memories (category);

CREATE INDEX IF NOT EXISTS idx_memories_tags_gin
    ON memories USING GIN (tags);

CREATE INDEX IF NOT EXISTS idx_memories_metadata_gin
    ON memories USING GIN (metadata_json);

CREATE TABLE IF NOT EXISTS memory_categories (
    name TEXT PRIMARY KEY,
    description TEXT NOT NULL DEFAULT ''
);

INSERT INTO memory_categories (name, description) VALUES
    ('project_note', 'General project notes'),
    ('market_observation', 'Market or trading observations'),
    ('droidhead_idea', 'Droidhead concepts and future ideas'),
    ('prompt_pattern', 'Reusable prompt structures and patterns'),
    ('lesson_learned', 'Lessons learned from work or experiments'),
    ('person_note', 'Notes about people, contacts, collaborators'),
    ('decision', 'Architecture or project decisions'),
    ('meeting_note', 'Meeting summaries and extracted notes'),
    ('research', 'Research findings and reference notes'),
    ('bug_fix', 'Bug investigations and resolutions'),

    ('cms_signal', 'Crispy Market Sentinel signal records'),
    ('cms_reason_code', 'CMS explanation and reason code notes'),
    ('droidhead_inventory', 'Droidhead inventory and parts notes'),
    ('n8n_workflow_note', 'n8n workflow design or operational notes'),
    ('self_hosting_issue', 'Infrastructure and self-hosting issues')
ON CONFLICT (name) DO NOTHING;

ALTER TABLE memories
    ADD CONSTRAINT fk_memories_category
    FOREIGN KEY (category)
    REFERENCES memory_categories(name);
