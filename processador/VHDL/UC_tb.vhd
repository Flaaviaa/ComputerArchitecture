library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC_tb is
    end entity;

architecture a_UC_tb of UC_tb is
    signal signal_instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal signal_rst : std_logic := '0';
    signal signal_estado : unsigned(1 downto 0) := "00";
    signal signal_instrucao_branch : std_logic := '0';
    signal signal_instrucao_jump : std_logic := '0';
    signal signal_select_mux_pc : unsigned(1 downto 0) := "00";
    signal signal_wr_en_pc : std_logic := '1';
    signal signal_select_ula_op : unsigned(1 downto 0) := "00";
    signal signal_instrucao_zera_ula : std_logic := '0';
    signal signal_select_mux_ula : std_logic := '0'; -- seleciona 1 para constante e 0 para registrador
    signal signal_reg_wr_en : std_logic := '1'; 
    signal signal_selec_reg1 : unsigned(2 downto 0) := "000";
    signal signal_registrador_para_salvar : unsigned(2 downto 0) := "000";
    signal signal_select_mux_input_regs : std_logic := '1';
    signal signal_acc_wr_en : std_logic := '0';
    signal signal_select_mux_acc : unsigned(1 downto 0) := "00";
    signal signal_erro_instrucao : unsigned(3 downto 0) := "0000";
    signal signal_brake : std_logic := '0';

    signal contador : unsigned(3 downto 0) := "0000";
    
    type mem is array (0 to 15) of unsigned(15 downto 0);
    constant valores_teste : mem := (
        0 =>    B"000_000_000_000_000_0",   -- Bolha
        1 =>    B"101_1_000_0_00001100",   -- LD A,12
        2 =>    B"101_1_001_0_00010111",   -- LD R2,23 COM ERRO
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

    component UC is
        port(
            instrucao : in unsigned(15 downto 0);
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            instrucao_branch : out std_logic;
            instrucao_jump : out std_logic;
            select_mux_pc : out unsigned(1 downto 0);
            instrucao_jumpbit5 : out std_logic := '0';
            wr_en_pc : out std_logic;
            select_ula_op : out unsigned(1 downto 0);
            instrucao_zera_ula : out std_logic;
            select_mux_ula : out std_logic; 
            reg_wr_en : out std_logic; 
            selec_reg1 : out unsigned(2 downto 0);
            registrador_para_salvar : out unsigned(2 downto 0);
            select_mux_input_regs : out std_logic;
            acc_wr_en : out std_logic;
            select_mux_acc : out unsigned(1 downto 0);
            erro_instrucao : out unsigned(3 downto 0);
            brake : out std_logic
        );
    end component;

    begin 
        uut : UC port map(
            instrucao => signal_instrucao,
            rst => signal_rst,
            estado => signal_estado,
            instrucao_branch => signal_instrucao_branch,
            instrucao_jump => signal_instrucao_jump,
            select_mux_pc => signal_select_mux_pc,
            wr_en_pc => signal_wr_en_pc,
            select_ula_op => signal_select_ula_op,
            instrucao_zera_ula => signal_instrucao_zera_ula,
            select_mux_ula => signal_select_mux_ula,
            reg_wr_en => signal_reg_wr_en,
            selec_reg1 => signal_selec_reg1,
            registrador_para_salvar => signal_registrador_para_salvar,
            select_mux_input_regs => signal_select_mux_input_regs,
            acc_wr_en => signal_acc_wr_en,
            select_mux_acc => signal_select_mux_acc,
            erro_instrucao => signal_erro_instrucao,
            brake => signal_brake
        );

        process
            begin 
                while contador /= "1111" loop
                    signal_instrucao <= valores_teste(to_integer(contador));
                    wait for 50 ns;
                    contador <= contador + 1;

                end loop;
                wait;
        end process;


end architecture;