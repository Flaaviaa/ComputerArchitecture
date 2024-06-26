library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_de_registradores_tb is
    end;

    architecture a_banco_de_registradores_tb of banco_de_registradores_tb is
        component banco_de_registradores is
            port (  reg_select_1      : in unsigned(2 downto 0);
                    reg_select_2      : in unsigned(2 downto 0);     
                    regWrite          : in unsigned(2 downto 0);
                    entr             : in unsigned(15 downto 0);
                    wr_en             : in std_logic;
                    clk               : in std_logic;
                    rst               : in std_logic;
                    reg_data1         : out unsigned(15 downto 0) := "0000000000000000";  
                    reg_data2         : out unsigned(15 downto 0) := "0000000000000000" 
            );
        end component;

        constant period_time : time      := 100 ns;
        signal   finished    : std_logic := '0';
        signal   clk, rst, wr_en, reset  : std_logic;
        signal   entr, reg_data1, reg_data2 : unsigned(15 downto 0);
        signal   reg_select_1, reg_select_2, regWrite : unsigned(2 downto 0);

    begin
        uut: banco_de_registradores port map(
            reg_select_1 => reg_select_1,
            reg_select_2 => reg_select_2,
            regWrite => regWrite,
            entr => entr,
            wr_en => wr_en,
            clk => clk,
            rst => reset,
            reg_data1 => reg_data1,
            reg_data2 => reg_data2
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
      reg_select_1 <= "001";
      reg_select_2 <= "010";
      wait for 100 ns;
      reg_data1 <= "1000110110001101";
      reg_data2 <= "1010010110110101";
      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
   end process;
end architecture a_banco_de_registradores_tb;
