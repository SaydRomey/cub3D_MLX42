/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   draw_shapes.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/12/20 15:42:47 by cdumais           #+#    #+#             */
/*   Updated: 2023/12/20 15:44:34 by cdumais          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cub3d.h"

void	draw_circle(mlx_image_t *img, t_point origin, int radius, int color)
{
	int	i;
	int	j;
	int	distance_squared;
	int	radius_squared;

	radius_squared = radius * radius;
	i = 0;
	while (i < radius * 2)
	{
		j = 0;
		while (j < radius * 2)
		{
			// Calculate the distance from the center of the circle to the current pixel
			distance_squared = (i - radius) * (i - radius) + (j - radius) * (j
					- radius);
			// Check if the current pixel is within the circle's radius
			if (distance_squared < radius_squared)
				draw_pixel(img, origin.x - radius + j, origin.y - radius + i,
						color);
			j++;
		}
		i++;
	}
}

void	draw_circle_hollow(mlx_image_t *img, t_point origin, int radius, int thickness, int color)
{
	int	i;
	int	j;
	int	distance_squared;
	int	radius_squared;
	int	inner_radius_squared;

	radius_squared = radius * radius;
	inner_radius_squared = (radius - thickness) * (radius - thickness);
	i = 0;
	while (i < radius * 2)
	{
		j = 0;
		while (j < radius * 2)
		{
			distance_squared = (i - radius) * (i - radius) + (j - radius) * (j
					- radius);
			if (distance_squared < radius_squared
				&& distance_squared > inner_radius_squared)
				draw_pixel(img, origin.x - radius + j, origin.y - radius + i,
						color);
			j++;
		}
		i++;
	}
}

void	draw_triangle(mlx_image_t *img, t_point p1, t_point p2, t_point p3, int color)
{
	draw_line(img, p1, p2, color);
	draw_line(img, p2, p3, color);
	draw_line(img, p3, p1, color);
}

void	draw_rectangle(mlx_image_t *img, t_point origin, t_point end, int color)
{
	int	x;
	int	y;
	y = origin.y;
	while (y < origin.y + end.y)
	{
		x = origin.x;
		while (x < origin.x + end.x)
		{
			draw_pixel(img, x, y, color);
			x++;
		}
		y++;
	}
}
