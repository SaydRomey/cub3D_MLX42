/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/12/20 13:51:21 by cdumais           #+#    #+#             */
/*   Updated: 2023/12/20 16:11:39 by cdumais          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef UTILS_H
# define UTILS_H

# include "MLX42.h"
# include "libft.h"
# include <math.h>

# ifdef __linux__
#  define WIDTH				1366
#  define HEIGHT			768
#  define MINI_WIDTH		750 //to fix
#  define MINI_HEIGHT		750
# elif defined(__APPLE__) && defined(__MACH__)
#  define WIDTH				2560
#  define HEIGHT			1395
#  define MINI_WIDTH		750
#  define MINI_HEIGHT		750
# else
#  error "Unsupported Operating System"
# endif

/* bytes per pixel */
# define PIXEL_SIZE			4

# define PI					3.1415926535

# define PLAYER_SIZE		20
# define PLAYER_SPEED		3
# define SPEED_LIMIT		10
# define PLAYER_TURN_SPEED	5
# define MOUSE_SPEED		1


/* colors */ //need to check these...

# define HEX_BLACK			0x000000
# define HEX_GRAY			0x404040
# define HEX_WHITE			0xFFFFFF
# define HEX_RED			0xFF0000
# define HEX_GREEN			0x00FF00
# define HEX_BLUE			0x0000FF
# define HEX_YELLOW			0xFFFF00
# define HEX_MAGENTA		0xFF00FF
# define HEX_CYAN			0x00FFFF

# define HEX_ORANGE			0xED840C
# define HEX_ORANGE2		0xFF7700
# define HEX_PURPLE			0x800080
# define HEX_OLILAS			0xA27CF1
# define HEX_LILAC			0xFF22FF
# define HEX_PINK			0xFFC0CB
# define HEX_BROWN			0x663300

// # define GREEN      0x00FF00
// # define RED        0xFF0000
// # define YELLOW     0xFFFF00
// # define WHITE      0xFFFFFF
// # define BLACK      0x000000
// # define BLUE       0x0000FF
// # define PURPLE     0x800080
// # define ORANGE     0xFFA500
// # define PINK       0xFFC0CB
// # define BROWN      0xA52A2A
// # define GREY       0x808080
// # define CYAN       0x00FFFF
// # define LIME       0x00FF00
// # define MAGENTA    0xFF00FF
// # define OLIVE      0x808000
// # define MAROON     0x800000

#endif
