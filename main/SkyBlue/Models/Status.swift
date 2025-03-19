// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

enum Status {
    case loggedOut
    case loggingIn
    case connected(Session)
}
