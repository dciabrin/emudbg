/*
 * emudbg - emulator-agnostic source level debugging API
 * Copyright (c) 2018 Damien Ciabrini
 * This file is part of ngdevkit
 *
 * ngdevkit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * ngdevkit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with ngdevkit.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __GDBSERVER_H__
#define __GDBSERVER_H__

int emudbg_gdb_server_loop(void *emudbg_ctx, int emu_suspended, struct emudbg_cmd_t *next_cmd);

#endif /* __GDBSERVER_H__ */
