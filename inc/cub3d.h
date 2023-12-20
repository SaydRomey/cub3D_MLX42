/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cub3d.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/12/20 13:41:52 by cdumais           #+#    #+#             */
/*   Updated: 2023/12/20 16:05:54 by cdumais          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef CUB3D_H
# define CUB3D_H

# include "MLX42.h"
# include "utils.h"

typedef struct s_point
{
	float	x;
	float	y;
}			t_point;

typedef struct s_map
{
	int			tile_size;
	int			width;
	int			height;
	int			floor_color;
	int			ceiling_color;
	int			wall_tile_color;
	int			floor_tile_color;
}				t_map;

typedef struct s_player
{
	t_point		position;
	t_point		delta;
	float		angle;
	int			size;
	int			color;
	float		speed;
	float		turn_speed;
	float		mouse_turn_speed;
}				t_player;

typedef struct s_cub
{
	mlx_t		*mlx;
	mlx_image_t	*img;
	mlx_image_t	*mini;
	t_player	player;
	t_map		map;
}				t_cub;

// draw_shapes.c
// 
void		draw_circle(mlx_image_t *img, t_point origin, int radius, int color);
void		draw_circle_hollow(mlx_image_t *img, t_point origin, int radius, int thickness, int color);
void		draw_triangle(mlx_image_t *img, t_point p1, t_point p2, t_point p3, int color);
void		draw_rectangle(mlx_image_t *img, t_point origin, t_point end, int color);

// math_utils.c
// 
float	degree_to_radian(int degree);
int		fix_angle(int angle);
float	distance(t_point a, t_point b, float angle);

// pixels.c
// 
void		draw_pixel(mlx_image_t *img, int x, int y, int color);
void		draw_line(mlx_image_t *img, t_point start, t_point end, int color);

// player.c
// 
t_player	init_player(t_point start, char direction);
void		draw_player(mlx_image_t *img, t_player *player);

// minimap.c
// 
t_map		init_map(void);
void		draw_mini_map(mlx_image_t *img, t_map *map);

#endif
