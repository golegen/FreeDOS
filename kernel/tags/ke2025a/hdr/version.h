/****************************************************************/
/*                                                              */
/*                          version.h                           */
/*                                                              */
/*                  Common version information                  */
/*                                                              */
/*                      Copyright (c) 1997                      */
/*                      Pasquale J. Villani                     */
/*                      All Rights Reserved                     */
/*                                                              */
/* This file is part of DOS-C.                                  */
/*                                                              */
/* DOS-C is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License  */
/* as published by the Free Software Foundation; either version */
/* 2, or (at your option) any later version.                    */
/*                                                              */
/* DOS-C is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of   */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See    */
/* the GNU General Public License for more details.             */
/*                                                              */
/* You should have received a copy of the GNU General Public    */
/* License along with DOS-C; see the file COPYING.  If not,     */
/* write to the Free Software Foundation, 675 Mass Ave,         */
/* Cambridge, MA 02139, USA.                                    */
/****************************************************************/

#ifdef MAIN
#ifdef VERSION_STRINGS
static BYTE *date_hRcsId = "$Id: version.h 321 2001-11-13 23:36:45Z bartoldeman $";
#endif
#endif

/* This Kernel is at a min Dos Ver. 5.00 */

#define MAJOR_RELEASE   5
#define MINOR_RELEASE   00

#define REV_NUMBER      0
#define OEM_ID          0xfd    /* FreeDos version                      */

#define REVISION_MAJOR  1
#define REVISION_MINOR  1
#define REVISION_SEQ    25
#define BUILD           "2025"
#define SUB_BUILD	"a"
#define KERNEL_VERSION_STRING "1.1.25a" /*#REVISION_MAJOR "." #REVISION_MINOR "." #REVISION_SEQ*/
#define KERNEL_BUILD_STRING "2025a" /*#BUILD SUB_BUILD*/
