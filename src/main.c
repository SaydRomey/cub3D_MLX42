/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/12/20 13:43:54 by cdumais           #+#    #+#             */
/*   Updated: 2023/12/20 16:10:07 by cdumais          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cub3d.h"


void	clear_image(mlx_image_t *img)
{
	int	total_pixels;

	total_pixels = img->width * img->height * PIXEL_SIZE;
	ft_bzero(img->pixels, total_pixels);
}




void	background(mlx_image_t *img, int color)
{
	draw_rectangle(img, (t_point){0, 0}, (t_point){img->width, img->height}, color);
}

t_cub	init_cub(char *path)
{
	t_cub	cub;
	char	*title;

	title = ft_strjoin("cub3D - ", path);
	ft_memset(&cub, 0, sizeof(cub));
	cub.mlx = mlx_init(WIDTH, HEIGHT, "Title", TRUE);
	free(title);
	cub.img = mlx_new_image(cub.mlx, WIDTH, HEIGHT);
	mlx_image_to_window(cub.mlx, cub.img, 0, 0);
	cub.mini = mlx_new_image(cub.mlx, MINI_WIDTH, MINI_HEIGHT);
	mlx_image_to_window(cub.mlx, cub.mini, WIDTH - MINI_WIDTH, 0);
	background(cub.img, HEX_GRAY);
	background(cub.mini, HEX_GRAY);
	return (cub);
}

void	cub_loop(t_cub *cub)
{
	// hooks

	mlx_loop(cub->mlx);
}

int main(void)
{
	t_cub	cub;
	t_point	start = {MINI_WIDTH / 2, MINI_HEIGHT / 2};

	cub = init_cub("[map title]");

	cub.map = init_map();
	draw_mini_map(cub.mini, &cub.map);

	cub.player = init_player(start, 'S');
	draw_player(cub.mini, &cub.player);

	cub_loop(&cub);
	// 
	mlx_delete_image(cub.mlx, cub.img);
	mlx_delete_image(cub.mlx, cub.mini);
	mlx_terminate(cub.mlx);
	// 
	return (0);
}
