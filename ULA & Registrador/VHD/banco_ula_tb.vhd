library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_ula_tb is
    end;

    architecture a_banco_ula_tb of banco_ula_tb is
        component banco_ula
            port(   
                clk                        : in std_logic;
                rst                        : in std_logic;
                wr_en                      : in std_logic;
                mux_select                 : in std_logic; 
                operacao_ula               : in unsigned(1 downto 0);
                select_reg_1               : in unsigned(2 downto 0);
                select_reg_2               : in unsigned(2 downto 0);
                valor_entrada              : in unsigned(15 downto 0);
                regWrite                   : in unsigned(2 downto 0);
                result                     : out unsigned(15 downto 0)
            );
            end component;

            constant period_time 	                      : time		:= 100 ns;
            signal finished     	                      : std_logic := '0';
            signal clk, rst, wr_en, mux_select, reset	  : std_logic;
            signal operacao_ula                           : unsigned(1 downto 0);
            signal select_reg_1, select_reg_2, regWrite   : unsigned(2 downto 0);
            signal valor_entrada                          : unsigned(15 downto 0);

        begin
            uut: banco_ula port map(
                clk             => clk,
                rst             => rst,
                wr_en           => wr_en,
                mux_select      => mux_select, 
                operacao_ula    => operacao_ula,
                select_reg_1    => select_reg_1,
                select_reg_2    => select_reg_2,
                valor_entrada   => valor_entrada,
                regWrite        => regWrite
            );

        reset_global: process
        begin
            reset <= '1';
            wait for period_time*2; -- espera 2 clocks, pra garantir
            reset <= '0';
            wait;
        end process reset_global;

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

        process
        begin 
            rst <= '1';
            wr_en <= '1';
            wait for 200 ns;
            rst <= '0';
            select_reg_1 <= "000"; -- x0

            -- addi x1,zero,1; -> x1 = 0 + 2 = 2
            regWrite <= "001"; -- x1
            select_reg_1 <= "000"; -- x0
            valor_entrada <= "0000000000000010"; -- 2
            mux_select <= '1'; -- pega o dado do valor de entrada
            operacao_ula <= "00"; -- soma
            wait for 100 ns;

            -- addi x2,zero,18; -> x2 = 0 + 20 = 20
            regWrite <= "010"; -- x2
            select_reg_1 <= "000"; -- x0
            valor_entrada <= "0000000000010100"; -- 20
            mux_select <= '1'; -- -- pega o dado do valor de entrada
            operacao_ula <= "00"; -- soma
            wait for 100 ns;

            -- add x3,x1,x2; -> x3 = 2 + 20 = 22
            regWrite <= "011"; -- x3
            select_reg_1 <= "001"; -- x1
            select_reg_2 <= "010"; -- x2
            mux_select <= '0'; -- pega o valor do registrador
            operacao_ula <= "00"; -- soma
            wait for 100 ns;

            ------------------------------------------------------------------------------

            -- subi x4, 30, x3 -> x4 = 30 - 22 = 8
            regWrite <= "100"; -- x4
            select_reg_1 <= "011"; -- x3
            valor_entrada <= "0000000000011110";
            mux_select <= '1'; -- pega o valor de entrada
            operacao_ula <= "01"; -- subtração
            wait for 100 ns;

            -- sub x5, x3, x1 -> x5 = 22 - 20 = 2
            regWrite <= "101"; -- x5
            select_reg_1 <= "100"; -- x4
            select_reg_2 <= "001"; -- x1
            mux_select <= '0'; -- pega o valor do registrador
            operacao_ula <= "01"; -- subtração
            wait for 100 ns;

            ------------------------------------------------------------------------------

            -- valores iguais 
            regWrite <= "110"; -- x6
            select_reg_1 <= "101"; -- x5
            valor_entrada <= "0000000000000010";
            mux_select <= '1'; -- pega o valor da entrada
            operacao_ula <= "11"; --comparação =
            wait for 100 ns;

            -- a maior que b sendo a e b positivos
            regWrite <= "111"; -- x7
            select_reg_1 <= "100"; -- x4
            select_reg_2 <= "101"; -- x5
            mux_select <= '0'; -- pega o valor do registrador
            operacao_ula <= "10"; -- comparação >
            wait for 100 ns;
        wait;
        end process;

    end architecture;