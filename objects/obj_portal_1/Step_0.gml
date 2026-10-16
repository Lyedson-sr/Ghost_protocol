if place_meeting(x,y, obj_player) && !instance_exists(obj_dist_1)//sea instancia não existir podemos executar esse codigo
	{
		//sempre que criarmos o objeto o definiremos em uma profundidade apropriada
		//algo legal que podemos fazer sempre que criamos novas instancias é armazenar o id dessa nova instancia com uma variavel
	var inst = instance_create_depth(0,0, -9999, obj_dist_1);
	global.portal_target_x = target_x;
	global.portal_target_y = target_y;
	global.portal_target_rm = target_rm;
	}
	
	// Se jogador corre para o local de distroção e ele não existe podemos criar esse objeto de distorção 