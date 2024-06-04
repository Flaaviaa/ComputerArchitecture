library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DECODER_PACKAGE_TB is
    
end entity;

architecture A_DECODER_PACKAGE_TB of DECODER_PACKAGE_TB is
    signal clk : std_logic := '1';
    signal rst : std_logic := '0';
    signal instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal bit5 : std_logic := '0';
    signal estado : unsigned(1 downto 0) := "00";
    signal saida_ula : unsigned(15 downto 0) := "0000000000000000";
    signal wr_en_pc : std_logic := '1';
    signal endereco_pc : unsigned(6 downto 0) := "0000000";
    signal instrucao_branch : std_logic := '1';
    signal instrucao_jump : std_logic := '1';
    signal instrucao_zera_flags_ula : std_logic := '1';
    signal instrucao_jumpbit5 : std_logic := '1';
    signal ina_ula : unsigned(15 downto 0) := "0000000000000000";
    signal inb_ula : unsigned(15 downto 0) := "0000000000000000";
    signal select_op_ula : unsigned(1 downto 0) := "00";
    signal select_mux_pc : unsigned(1 downto 0) := "00";
    signal instrucao_erro : unsigned(3 downto 0) := "0000";
    signal brake_erro : std_logic := '1';

    signal contador : unsigned(6 downto 0) := "0000000";
    signal endereco : unsigned(3 downto 0) := "0000";
    
    type mem is array (0 to 15) of unsigned(15 downto 0);
    constant valores_teste : mem := (
        0 =>    B"000_000_000_000_000_0",   -- Bolha
        1 =>    B"101_1_000_1_00001100",   -- LD A,12
        2 =>    B"101_1_010_0_00010111",   -- LD R2,23 COM ERRO
        3 =>    B"100_1_111_0_00000000",   -- MOV A,R1
        4 =>    B"001_1_010_000_000000",   -- ADD A,R2
        5 =>    B"100_1_111_0_00000000",   -- MOV A,R7
        6 =>    B"111_00_0_000_0000000",   -- COMP A,R2
        7 =>    B"111_01_0_000_0001100",   -- COMP R3.12,11
        8 =>    B"000_000_100_000_000_0",   -- Bolha COM ERRO
        9 =>    B"110_00_0_000_0000011",   -- JUMP 3 
        10 =>   B"110_01_1_000_0001100",   -- BRANCH CR,12
        11 =>   B"010_1_000_0_00000001",   -- ADDI A,1
        12 =>   B"011_1_111_0_00000000",   -- SUB A,R2
        13 =>   B"000_000_000_000_000_0",
        others => (others => '0')
    );

    component DECODER_PACKAGE is
        port(
            clk : in std_logic;
            rst : in std_logic;
            instrucao : in unsigned(15 downto 0);
            estado : in unsigned(1 downto 0);
            bit5 : out std_logic;
            saida_ula : in unsigned(15 downto 0);
            wr_en_pc : out std_logic;
            endereco_pc : out unsigned(6 downto 0);
            instrucao_branch : out std_logic;
            instrucao_jump : out std_logic;
            instrucao_zera_flags_ula : out std_logic;
            instrucao_jumpbit5 : out std_logic;
            ina_ula : out unsigned(15 downto 0);
            inb_ula : out unsigned(15 downto 0);
            select_op_ula : out unsigned(1 downto 0);
            select_mux_pc : out unsigned(1 downto 0);
            instrucao_erro : out unsigned(3 downto 0);
            brake_erro : out std_logic
        );
    end component;

    begin 
        uut : DECODER_PACKAGE port map(
            clk => clk,
            rst => rst,
            instrucao => instrucao,
            estado => estado,
            saida_ula => saida_ula,
            bit5 => bit5,
            wr_en_pc => wr_en_pc,
            endereco_pc => endereco_pc,
            instrucao_branch => instrucao_branch,
            instrucao_jump => instrucao_jump,
            instrucao_zera_flags_ula => instrucao_zera_flags_ula,
            instrucao_jumpbit5 => instrucao_jumpbit5,
            ina_ula => ina_ula,
            inb_ula => inb_ula,
            select_op_ula => select_op_ula,
            select_mux_pc => select_mux_pc,
            instrucao_erro => instrucao_erro,
            brake_erro => brake_erro
        );

        clocker : process
            begin 
                while contador /= "1111111" loop
                    wait for 10 ns;
                    clk <= '0';
                    instrucao <= valores_teste(to_integer(endereco));
                    wait for 10 ns;
                    clk <= '1';
                    if estado = "10" then
                        estado <= "00";
                        
                    else
                        estado <= estado + 1;
                    end if;
                    contador <= contador + 1;
                    if endereco /= "1111"  then
                        if estado = "10" then
                        endereco <= endereco + 1;
                        end if;
                    else
                        endereco <= "0000";
                    end if;
                end loop;
                wait;
        end process clocker;

end architecture;