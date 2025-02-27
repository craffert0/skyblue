// The basic idea for namespacing is to define the entire set of namespaces in
// a nested enum up front. Then each json object is in an extension of the
// fully qualified enum.

public enum app {
    public enum bsky {
        public enum actor {}
        public enum embed {}
        public enum feed {}
        public enum graph {}
        public enum labeler {}
        public enum notification {}
        public enum richtext {}
        public enum unspecced {}
        public enum video {}
    }
}

public enum chat {
    public enum bsky {
        public enum actor {}
        public enum convo {}
        public enum moderation {}
    }
}

public enum com {
    public enum atproto {
        public enum admin {}
        public enum identity {}
        public enum label {}
        public enum moderation {}
        public enum repo {}
        public enum server {}
        public enum sync {}
        public enum temp {}
    }
}

public enum tools {
    public enum ozone {
        public enum communication {}
        public enum moderation {}
        public enum server {}
        public enum set {}
        public enum setting {}
        public enum signature {}
        public enum team {}
    }
}
