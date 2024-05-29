library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FATCH_PACKAGE_TB is
end entity;


architecture A_FATCH_PACKAGE_TB of FATCH_PACKAGE_TB is
    signal contador : unsigned(4 downto 0) := "00000";

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal estado : unsigned(1 downto 0) := "00";
    signal fet_wr_en_pc : std_logic := '1';
    signal fet_somar_pc : std_logic := '0';
    signal fet_saltar_pc : std_logic := '0';
    signal fet_endereco_entrada_pc : unsigned(6 downto 0) := "0010011";
    signal fet_overflow_flag_ula : std_logic := '0';
    signal fet_instrucao_branch : std_logic := '0';
    signal fet_instrucao : unsigned(15 downto 0):= "0000000000000000";

    component FATCH_PACKAGE is
        port(
            -- controle
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            -- entrada
            fet_wr_en_pc : in std_logic;
            fet_somar_pc : in std_logic;
            fet_saltar_pc : in std_logic;
            fet_endereco_entrada_pc : in unsigned(6 downto 0);
            fet_overflow_flag_ula : in std_logic;
            fet_instrucao_branch : in std_logic;
            -- saída
            fet_instrucao : out unsigned(15 downto 0)
        );
    end component;
    begin
        uut : FATCH_PACKAGE port map(
            rst => rst, 
            clk => clk, 
            estado => estado, 
            fet_wr_en_pc => fet_wr_en_pc, 
            fet_somar_pc => fet_somar_pc, 
            fet_saltar_pc => fet_saltar_pc,
            fet_endereco_entrada_pc => fet_endereco_entrada_pc, 
            fet_overflow_flag_ula => fet_overflow_flag_ula,
            fet_instrucao_branch => fet_instrucao_branch,
            fet_instrucao => fet_instrucao
        );

        overflow_somar : process
            begin
                wait for 500 ns;
                fet_somar_pc <= '1';
                fet_overflow_flag_ula <= '1';
                wait for 250 ns;
                
                fet_instrucao_branch <= '0';
                fet_somar_pc <= '0';
                fet_overflow_flag_ula <= '0';
                fet_saltar_pc <= '0';
                wait for 100 ns;

                fet_somar_pc <= '0';
                fet_overflow_flag_ula <= '1';
                fet_saltar_pc <= '1';
                wait for 250 ns;

                fet_instrucao_branch <= '0';
                fet_somar_pc <= '0';
                fet_overflow_flag_ula <= '0';
                fet_saltar_pc <= '0';
                wait for 50 ns;

                fet_saltar_pc <= '0';
                fet_instrucao_branch <= '1';
                fet_overflow_flag_ula <= '1';
                wait for 250 ns;

                fet_instrucao_branch <= '0';
                fet_somar_pc <= '0';
                fet_overflow_flag_ula <= '0';
                fet_saltar_pc <= '0';
                wait for 100 ns;
                
                fet_instrucao_branch <= '0';
                fet_somar_pc <= '0';
                fet_overflow_flag_ula <= '0';
                fet_saltar_pc <= '0';
                wait;
        end process overflow_somar;



        process
            begin 
                while contador /= "11111" loop
                    wait for 50 ns;
                    clk <= '0';
                    wait for 50 ns;
                    clk <= '1';
                    contador <= contador + 1;

                    if estado = "10" then 
                        estado <= "00";
                    else
                        estado <= estado + 1;
                    end if;
                end loop;
                wait;
        end process;

end architecture;