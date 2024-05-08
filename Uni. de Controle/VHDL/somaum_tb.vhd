library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somaum_tb is
    end;

    architecture a_somaun_tb of somaum_tb is
        component somaum
        port(   
            clk          : in std_logic;
            entrada      : in unsigned(15 downto 0);
            saida        : out unsigned(15 downto 0)
        );
        end component;

        constant period_time : time      := 100 ns;
        signal   finished    : std_logic := '0';
        signal   clk         : std_logic;          
        signal   entrada, saida_maisum : unsigned(15 downto 0);

    begin
        uut: somaum port map(
            clk => clk,
            entrada => entrada,
            saida => saida_maisum
        );
    
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
      entrada <= "0000000000000001";
      wait for 100 ns;
      wait for 100 ns;
      wait for 100 ns;
      wait for 100 ns;
      wait for 100 ns;
      wait for 100 ns;
      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
   end process;
end architecture;
