library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC_tb is
    end entity;

architecture a_UC_tb of UC_tb is
    signal instrucao : unsigned(15 downto 0);
    signal select_mux_input_regs : std_logic; -- 
    signal select_ula_op : unsigned(1 downto 0);
    signal select_mux_ula : std_logic; -- seleciona 1 para constante e 0 para registrador
    signal instrucao_beq : std_logic;
    signal reg_wr_en : std_logic; 
    signal wr_reg_andress : unsigned(2 downto 0);
    signal selec_reg1 : unsigned(2 downto 0);
    signal selec_reg2 : unsigned(2 downto 0);
    signal registrador_para_salvar : unsigned(2 downto 0);

    signal contador : unsigned(2 downto 0) := "000";
    
    type mem is array (0 to 7) of unsigned(15 downto 0);
    constant valores_teste : mem := (
        0 => "1000111110001000",
        1 => "1001111010011001",
        2 => "1010110110101010",
        3 => "1011110010111011",
        4 => "1100101111001100",
        5 => "1101101011011101",
        6 => "1110100111101110",
        7 => "1111100011111111",
        others => (others => '0')
    );

    component UC is
        port(
            instrucao : in unsigned(15 downto 0);
            select_mux_input_regs : out std_logic; -- 
            select_ula_op : out unsigned(1 downto 0);
            select_mux_ula : out std_logic; -- seleciona 1 para constante e 0 para registrador
            instrucao_beq : out std_logic;
            reg_wr_en : out std_logic; 
            wr_reg_andress : out unsigned(2 downto 0);
            selec_reg1 : out unsigned(2 downto 0);
            selec_reg2 : out unsigned(2 downto 0);
            registrador_para_salvar : out unsigned(2 downto 0)
        );
    end component;

    begin 
        uut : UC port map(
            instrucao => instrucao,
            select_mux_input_regs => select_mux_input_regs,
            select_ula_op => select_ula_op,
            select_mux_ula => select_mux_ula,
            instrucao_beq => instrucao_beq,
            reg_wr_en => reg_wr_en,
            wr_reg_andress => wr_reg_andress,
            selec_reg1 => selec_reg1,
            selec_reg2 => selec_reg2,
            registrador_para_salvar => registrador_para_salvar
        );

        process
            begin 
                while contador /= "111" loop
                    instrucao <= valores_teste(to_integer(contador));
                    wait for 50 ns;
                    contador <= contador + 1;

                end loop;
                wait;
        end process;


end architecture;