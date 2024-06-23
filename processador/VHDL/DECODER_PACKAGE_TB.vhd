library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DECODER_PACKAGE_TB is
    
end entity;

architecture A_DECODER_PACKAGE_TB of DECODER_PACKAGE_TB is
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal estado : unsigned(1 downto 0) := "00";
    signal saida_ula : unsigned(15 downto 0) := "0000000000000000";
    signal dado_out_ram : unsigned(15 downto 0) := "0000000000000000";
    signal bit5 : std_logic := '0';
    signal wr_en_pc : std_logic := '0';
    signal endereco_pc : unsigned(6 downto 0) := "0000000";
    signal instrucao_branch : std_logic := '0';
    signal instrucao_jump : std_logic := '0';
    signal ina_ula : unsigned(15 downto 0) := "0000000000000000";
    signal inb_ula : unsigned(15 downto 0) := "0000000000000000";
    signal select_op_ula : unsigned(1 downto 0) := "00";
    signal select_mux_pc : unsigned(1 downto 0) := "00";
    signal instrucao_erro : unsigned(3 downto 0) := "0000";
    signal brake : std_logic := '0';
    signal wr_en_ram : std_logic := '0';
    signal endereco_ram : unsigned(15 downto 0) := "0000000000000000";
    signal dado_in_ram : unsigned(15 downto 0) := "0000000000000000";
    signal regflags_wr_en : std_logic := '0';
    signal regula_wr_en : std_logic := '0';

    signal contador : unsigned(6 downto 0) := "0000000";
    signal endereco : unsigned(3 downto 0) := "0000";
    
    type mem is array (0 to 15) of unsigned(15 downto 0);
    constant valores_teste : mem := (
        0 => B"101_0_011_0_01111010", -- LD R3,122;
        1 => B"010_1_000_0_11101100", -- LD A,236;
        2 => B"011_01_011_0_0000000", -- SW A,122;
        3 => B"010_1_000_0_00000000", -- LD A,0;
        4 => B"011_00_011_0_0000000", -- LW R3,122;
        others => (others => '0')
    );

    component DECODER_PACKAGE is
        port(
            clk : in std_logic := '0';
            rst : in std_logic := '0';
            instrucao : in unsigned(15 downto 0) := "0000000000000000";
            estado : in unsigned(1 downto 0) := "00";
            saida_ula : in unsigned(15 downto 0) := "0000000000000000";
            dado_out_ram : in unsigned(15 downto 0) := "0000000000000000";
            bit5 : out std_logic := '0';
            wr_en_pc : out std_logic := '0';
            endereco_pc : out unsigned(6 downto 0) := "0000000";
            instrucao_branch : out std_logic := '0';
            instrucao_jump : out std_logic := '0';
            ina_ula : out unsigned(15 downto 0) := "0000000000000000";
            inb_ula : out unsigned(15 downto 0) := "0000000000000000";
            select_op_ula : out unsigned(1 downto 0) := "00";
            select_mux_pc : out unsigned(1 downto 0) := "00";
            instrucao_erro : out unsigned(3 downto 0) := "0000";
            brake : out std_logic := '0';
            wr_en_ram : out std_logic := '0';
            endereco_ram : out unsigned(15 downto 0) := "0000000000000000";
            dado_in_ram : out unsigned(15 downto 0) := "0000000000000000";
            regflags_wr_en : out std_logic := '0';
            regula_wr_en : out std_logic := '0'
        );
    end component;

    begin 
        uut : DECODER_PACKAGE port map(
            clk => clk,
            rst => rst,
            instrucao => instrucao,
            estado => estado,
            saida_ula => saida_ula,
            dado_out_ram => dado_out_ram,
            bit5 => bit5,
            wr_en_pc => wr_en_pc,
            endereco_pc => endereco_pc,
            instrucao_branch => instrucao_branch,
            instrucao_jump => instrucao_jump,
            ina_ula => ina_ula,
            inb_ula => inb_ula,
            select_op_ula => select_op_ula,
            select_mux_pc => select_mux_pc,
            instrucao_erro => instrucao_erro,
            brake => brake,
            wr_en_ram => wr_en_ram,
            endereco_ram => endereco_ram,
            dado_in_ram => dado_in_ram,
            regflags_wr_en => regflags_wr_en,
            regula_wr_en => regula_wr_en
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