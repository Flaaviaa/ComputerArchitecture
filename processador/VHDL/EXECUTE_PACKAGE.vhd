library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXECUTE_PACKAGE is
    port(
        -- controle
        clk : in std_logic;
        rst : in std_logic;
        estado : in unsigned(1 downto 0);
        -- entrada
        exe_instrucao_jumpbi5 : in std_logic;
        exe_select_mux_pc : in unsigned(1 downto 0);
        exe_instrucao_zera_flags : in std_logic;
        exe_select_op_ula : in unsigned(1 downto 0);
        exe_ina_ula : in unsigned(15 downto 0);
        exe_inb_ula : in unsigned(15 downto 0);
        exe_bit5 : in std_logic;
        -- saída
        exe_result_ula : out unsigned(15 downto 0);
        exe_saida_mux_pc : out std_logic;
        exe_saida_mux_pc_ou_bit5 : out std_logic
    );
end entity;

architecture A_EXECUTE_PACKAGE of EXECUTE_PACKAGE is
    signal signal_ina : unsigned(15 downto 0) := "0000000000000000";
    signal signal_inb : unsigned(15 downto 0) := "0000000000000000";
    signal signal_operacaozeraula : std_logic := '0';
    signal signal_operationselect : unsigned(1 downto 0) := "00";
    signal signal_overflow : std_logic := '0';
    signal signal_biggest : std_logic := '0';
    signal signal_equal : std_logic := '0';

    signal signal_exe_saida_mux_pc : std_logic := '0';

    component ULA is
        port(
            ina : in unsigned(15 downto 0) := "0000000000000000";
            inb : in unsigned(15 downto 0) := "0000000000000000";
            operacaozeraula :in std_logic := '0';
            operationselect : in unsigned(1 downto 0) := "00";
            overflow : out std_logic := '0';
            biggest : out std_logic := '0';
            equal : out std_logic := '0';
            result : out unsigned(15 downto 0) := "0000000000000000"
        );
    end component;
    
    begin
    ULA_instance : ULA port map(
        ina => signal_ina,
        inb => signal_inb,
        operacaozeraula => exe_instrucao_zera_flags,
        operationselect => exe_select_op_ula,
        overflow => signal_overflow,
        biggest => signal_biggest,
        equal => signal_equal,
        result => exe_result_ula
    );
    -- conexoes
    signal_ina <= exe_ina_ula;
    signal_inb <= exe_inb_ula;
    exe_saida_mux_pc <= signal_exe_saida_mux_pc;
    -- comportamento do mux de 4 entradas de 1 bit e uma saída
    signal_exe_saida_mux_pc <=  signal_overflow when exe_select_mux_pc = "11" else
                                signal_biggest when exe_select_mux_pc = "01" else
                                signal_equal when exe_select_mux_pc = "10" else
                                '1';
    -- comportamento do component NOT do esquemático
    -- comportamento do mux de 2 entradas de 1 bit e uma saída
    exe_saida_mux_pc_ou_bit5 <= signal_exe_saida_mux_pc when exe_instrucao_jumpbi5 = '0' else
                                (not exe_bit5) when exe_instrucao_jumpbi5 = '1' else
                                '0';
end architecture;