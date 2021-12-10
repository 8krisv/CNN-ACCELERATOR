	component nios_system is
		port (
			clk_clk                                              : in  std_logic := 'X'; -- clk
			cnn_accelerator_avalon_0_control_signals_finished    : out std_logic;        -- finished
			cnn_accelerator_avalon_0_control_signals_finished_ok : in  std_logic := 'X'; -- finished_ok
			cnn_accelerator_avalon_0_control_signals_same_w      : in  std_logic := 'X'; -- same_w
			cnn_accelerator_avalon_0_control_signals_start       : in  std_logic := 'X'; -- start
			reset_reset_n                                        : in  std_logic := 'X'  -- reset_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                                              => CONNECTED_TO_clk_clk,                                              --                                      clk.clk
			cnn_accelerator_avalon_0_control_signals_finished    => CONNECTED_TO_cnn_accelerator_avalon_0_control_signals_finished,    -- cnn_accelerator_avalon_0_control_signals.finished
			cnn_accelerator_avalon_0_control_signals_finished_ok => CONNECTED_TO_cnn_accelerator_avalon_0_control_signals_finished_ok, --                                         .finished_ok
			cnn_accelerator_avalon_0_control_signals_same_w      => CONNECTED_TO_cnn_accelerator_avalon_0_control_signals_same_w,      --                                         .same_w
			cnn_accelerator_avalon_0_control_signals_start       => CONNECTED_TO_cnn_accelerator_avalon_0_control_signals_start,       --                                         .start
			reset_reset_n                                        => CONNECTED_TO_reset_reset_n                                         --                                    reset.reset_n
		);

