data:extend{
	{
		type = "int-setting",
		name = "conveyor-speed-scaling-factor",
		setting_type = "startup",
		default_value = 30,
		localised_name = "Conveyor speed scaling factor in %",
		minimum_value = 1
	},
	{
		type = "bool-setting",
		name = "enable-conveyor-speed-scaling",
		setting_type = "startup",
		localised_name = "Enable belt speed scaling",
		default_value = true
	},
	{
		type = "bool-setting",
		name = "enable-debug-messages",
		setting_type = "runtime-global",
		localised_name = "Enable debug messages",
		default_value = true
	}
}