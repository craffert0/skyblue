// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Model
import Schema

extension com.atproto.server.CreateSession.Output:
    @retroactive Session.Credentials {}

extension com.atproto.server.RefreshSession.Output:
    @retroactive Session.Credentials {}
