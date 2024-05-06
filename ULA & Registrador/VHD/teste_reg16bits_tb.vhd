library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity teste_reg16bits_tb is
    end;

    architecture a_teste_reg16bits_tb of teste_reg16bits_tb is
        component reg16bits
        port(   clk      : in std_logic;
                rst      : in std_logic;
                wr_en    : in std_logic;
                data_in  : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0)
        );
        end component;

        constant period_time : time      := 100 ns;
        signal   finished    : std_logic := '0';
        signal   clk, reset, wr_en  : std_logic;
        signal   data_in, data_out : unsigned(15 downto 0);

    begin
        uut: reg16bits port map(
            clk => clk,
            rst => reset,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
        );
    
    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;
    
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
      wr_en <= '0';
      data_in <= "1111111111111111";
      wait for 100 ns;
      data_in <= "1000110110001101";
      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
   end process;
end architecture a_teste_reg16bits_tb;
