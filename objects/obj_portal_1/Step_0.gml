if place_meeting(x,y, obj_player)
    && global.incidente_001_confirmado
    && !instance_exists(obj_dist_1)//sea instancia não existir podemos executar esse codigo
	{
		//sempre que criarmos o objeto o definiremos em uma profundidade apropriada
		//algo legal que podemos fazer sempre que criamos novas instancias é armazenar o id dessa nova instancia com uma variavel
	var inst = instance_create_depth(0,0, -9999, obj_dist_1)
	inst.target_x = target_x;
	inst.target_y = target_y;
	inst.target_rm = target_rm;
	}
	
	// Se jogador corre para o local de distroção e ele não existe podemos criar esse objeto de distorção 