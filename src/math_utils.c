/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   math_utils.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/12/20 16:05:02 by cdumais           #+#    #+#             */
/*   Updated: 2023/12/20 16:05:28 by cdumais          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cub3d.h"

float	degree_to_radian(int degree)
{
	return (degree * PI / 180.0);
}

int	fix_angle(int angle)
{
	if (angle > 359)
		angle -= 360;
	else if (angle < 0)
		angle += 360;
	return (angle);
}

/*
float distance(ax,ay,bx,by,ang){ return cos(degToRad(ang))*(bx-ax)-sin(degToRad(ang))*(by-ay);}
*/
float	distance(t_point a, t_point b, float angle)
{
	float	rad_angle;
	float	delta_x;
	float	delta_y;

	rad_angle = degree_to_radian(angle);
	delta_x = b.x - a.x;
	delta_y = b.y - a.y;
	return (cos(rad_angle) * delta_x - sin(rad_angle) * delta_y);
}
