/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   minimap.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/12/20 15:05:06 by cdumais           #+#    #+#             */
/*   Updated: 2023/12/20 15:38:10 by cdumais          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cub3d.h"

t_map	init_map(void)
{
	t_map	map;

	map.tile_size = 94;
	map.width = 8;
	map.height = 8;
	map.floor_color = HEX_BROWN;
	map.ceiling_color = HEX_BLUE;
	map.wall_tile_color = HEX_BLACK;
	map.floor_tile_color = HEX_WHITE;
	return (map);
}

void	draw_tile(mlx_image_t *img, t_point origin, t_point size, int color)
{
	int	x;
	int	y;

	y = origin.y;
	while (y < origin.y + size.y)
	{
		x = origin.x;
		while (x < origin.x + size.x)
		{
			draw_pixel(img, x, y, color);
			x++;
		}
		y++;
	}
}


/* tmp map to test */
void	draw_mini_map(mlx_image_t *img, t_map *map)
{
	int		x;
	int		y;
	t_point	tile;
	t_point	size;
	int		color;
	// 
	int		tmp_map[] = 
	{
		1,1,1,1,1,1,1,1,
		1,0,1,0,0,0,0,1,
		1,0,1,0,0,0,0,1,
		1,0,1,0,0,0,0,1,
		1,0,0,0,0,0,0,1,
		1,0,0,0,0,1,0,1,
		1,0,0,0,0,0,0,1,
		1,1,1,1,1,1,1,1,
	};
	//
	size.x = map->tile_size - 1;
	size.y = map->tile_size - 1;
	y = 0;
	while (y < map->height)
	{
		x = 0;
		while (x < map->width)
		{
			tile.x = x * map->tile_size;
			tile.y = y * map->tile_size;
			if (tmp_map[y * map->width + x] == 1)
				color = map->wall_tile_color;
			else
				color = map->floor_tile_color;
			draw_tile(img, tile, size, color);
			x++;
		}
		y++;
	}
}
