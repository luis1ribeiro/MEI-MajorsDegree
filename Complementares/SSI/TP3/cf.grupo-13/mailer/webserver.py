#!/usr/bin/env python3

import os
from datetime import timedelta
from datetime import datetime
import websockets
import sys
import webbrowser
import asyncio
import functools
import secrets
import json


async def check(websocket, path, code, ts, result):
    await websocket.send(json.dumps({"type":"start"}))
    async for message in websocket:
        if secrets.compare_digest(message, code) and (datetime.now() - ts < timedelta(seconds=30)):
            await websocket.send(json.dumps({"type":"code", "value": True}))
            asyncio.get_event_loop().stop()
            result.success()
            break
        else: 
            await websocket.send(json.dumps({"type":"code", "value": False}))


def open_browser():
    webbrowser.open("file://" + os.path.abspath("web.html"), new=2)


def start_server(code, ts, result):
    bound_handler = functools.partial(check, code=code, ts=ts, result=result)
    server = websockets.server.serve(bound_handler, "localhost", 5454)
    asyncio.get_event_loop().run_until_complete(server)
    asyncio.get_event_loop().run_forever()