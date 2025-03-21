// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public enum Status {
    case loggedOut
    case loggingIn
    case connected(Session)
}
