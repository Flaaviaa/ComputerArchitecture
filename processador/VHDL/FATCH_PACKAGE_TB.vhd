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
    signal fet_instrucao_branch : std_logic := '0';
    signal fet_instrucao_jump : std_logic := '0';
    signal fet_saida_mux_pc_ou_bit5 : std_logic := '0';
    signal fet_saida_mux_pc : std_logic := '0';
    signal fet_endereco_entrada_pc : unsigned(6 downto 0) := "0000000";
    signal fet_instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal fet_erro_endereco : std_logic := '0';

    component FATCH_PACKAGE is
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            fet_wr_en_pc : in std_logic;
            fet_instrucao_branch : in std_logic;
            fet_instrucao_jump : in std_logic;
            fet_saida_mux_pc_ou_bit5 : in std_logic;
            fet_saida_mux_pc : in std_logic;
            fet_endereco_entrada_pc : in unsigned(6 downto 0);
            fet_instrucao : out unsigned(15 downto 0);
            fet_erro_endereco : out std_logic
        );
    end component;
    begin
        uut : FATCH_PACKAGE port map(
            clk => clk,
            rst => rst,
            estado => estado,
            fet_wr_en_pc => fet_wr_en_pc,
            fet_instrucao_branch => fet_instrucao_branch,
            fet_instrucao_jump => fet_instrucao_jump,
            fet_saida_mux_pc_ou_bit5 => fet_saida_mux_pc_ou_bit5,
            fet_saida_mux_pc => fet_saida_mux_pc,
            fet_endereco_entrada_pc => fet_endereco_entrada_pc,
            fet_instrucao => fet_instrucao,
            fet_erro_endereco => fet_erro_endereco
        );


        process
            begin 
                while contador /= "11111" loop
                    
                    clk <= '0';
                    wait for 50 ns;
                    clk <= '1';
                    contador <= contador + 1;
                    wait for 50 ns;

                    fet_instrucao_branch <= contador(0);
                    fet_instrucao_jump <= contador(1);
                    fet_saida_mux_pc_ou_bit5 <= contador(2);
                    fet_saida_mux_pc <= contador(4);
                    fet_endereco_entrada_pc <= "0100000";

                    if estado = "10" then 
                        estado <= "00";
                    else
                        estado <= estado + 1;
                    end if;
                end loop;
                wait;
        end process;

end architecture;