#! /usr/bin/env python3

import json
import os.path

from http.client import *
from pathlib import Path


class Server:
    def __init__(self):
        self.cursor = None
        self.conn = HTTPSConnection("bsky.social")
        cred_string = Path(os.path.expanduser("~/.skybluerc")).read_text()
        self.conn.request(
            "POST",
            "/xrpc/com.atproto.server.createSession",
            headers={"Content-Type": "application/json"},
            body=cred_string,
        )
        response = self.conn.getresponse()
        print(response.status, response.reason)
        assert response.status == 200, response.reason
        body = json.loads(response.read())
        self.accessJwt = body["accessJwt"]
        self.refreshJwt = body["refreshJwt"]

    def getTimeline(self, limit=10):
        args = {"limit": limit}
        if self.cursor is not None:
            args["cursor"] = self.cursor
        arg = "&".join([f"{x[0]}={x[1]}" for x in list(args.items())])
        print(arg)
        self.conn.request(
            "GET",
            f"/xrpc/app.bsky.feed.getTimeline?{arg}",
            headers={"Authorization": f"Bearer {self.accessJwt}"},
        )
        response = self.conn.getresponse()
        print(response.status, response.reason)
        assert response.status == 200, response.reason
        result = json.loads(response.read())
        self.cursor = result["cursor"]
        return result


def main():
    server = Server()
    feed = server.getTimeline()
    print(json.dumps(feed, indent=2))
    feed = server.getTimeline()
    print(json.dumps(feed, indent=2))


if __name__ == "__main__":
    main()
