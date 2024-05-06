library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_e_ula_tb is
end;

architecture a_banco_ula_tb of banco_ula_tb is
    component banco_ula
        port(   clk                        : in std_logic;
                rst                        : in std_logic;
                wr_en                      : in std_logic;
                mux_select                 : in std_logic; 
                operacao_ula               : in unsigned(1 downto 0);
                select_reg_1               : in unsigned(2 downto 0);
                select_reg_2               : in unsigned(2 downto 0);
                valor_entrada              : in unsigned(15 downto 0);
                regWrite                   : in unsigned(2 downto 0)
            );
        end component;

        constant period_time 	: time		:= 100 ns;
		signal finished, wr_en	: std_logic := '0';
		signal clk, rst	        : std_logic;

    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;
    
    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process                      -- sinais dos casos de teste (p.ex.)
    begin 
        wait for 200 ns;
        wr_en <= '1';
        wait for 100 ns;
        wr_en <= '0';
        wait;
    end process;

    process                      -- sinais dos casos de teste (p.ex.)
    begin
      wait for 100 ns;
      select_reg_1 <= "001";
      select_reg_2 <= "010";
      clk <= '0';
      mux_select <= '1';
      valor_entrada <= '0010110110110110';
      wr_en <= '1';
      wait for 100 ns;
      clk <= '1';
      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
   end process;
end architecture a_banco_ula_tb;