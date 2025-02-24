// The basic idea for namespacing is to define the entire set of namespaces in
// a nested enum up front. Then each json object is in an extension of the
// fully qualified enum.

public enum atproto {
    public enum app {
        public enum bsky {
            public enum actor {}
            public enum feed {}
        }
    }
}
