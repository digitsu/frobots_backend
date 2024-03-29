export const MY_TOOLBOX = `
<xml id="toolbox" style="display: none">
    <category name="Frobot Blocks" colour="20" id="frobot-functions">
      <block type="frobot">
        <value name="initial_state"></value>
        <statement name="nested_blocks"></statement>
      </block>
      <block type="set_fsm_state">
        <value name="STATE">
          <shadow type="text">
            <field name="TEXT">newstate</field>
          </shadow>
        </value>
      </block>
      <block type="get_fsm_state" name="get_fsm_state"></block>
      <block type="transition_if">
        <value name="IF0">
          <shadow type="text">
          <field name="TEXT">state 1</field>
          </shadow>
        </value>
        <statement name="DO0"></statement>
        <mutation elseif="2" else="1"></mutation>
      </block>
      <block type="exit_block" name="exit_block">
        <value name="condition">
          <shadow type="logic_boolean">
            <field name="BOOL">TRUE</field>
          </shadow>
        </value>
        <value name="state">
          <shadow type="text">
            <field name="TEXT">newstate</field>
          </shadow>
        </value>
        <statement name="nested_blocks"></statement>
      </block>
      <block type="custom_return" name="custom_return"></block>
      <block type="speed" name="speed"></block>
      <block type="damage" name="damage"></block>
      <block type="drive" name="drive"></block>
      <block type="cannon" name="cannon"></block>
      <block type="cannon_2" name="cannon"></block>
      <block type="scan" name="scan"></block>
      <block type="set_cannon" name="set_cannon">
        <value name="cannon_id">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
      <block type="set_scanner" name="set_scanner">
        <value name="scanner_id">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
      <block type="xlocation" name="xlocation"></block>
      <block type="ylocation" name="ylocation"></block>
      <block type="os_time" name="os_time"></block>
      <block type="os_execute_sleep" name="os_execute_sleep">
        <value name="SECONDS">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
      <block type="set_state_property"></block>
      <block type="get_state_property"></block>
      <block type="change_state_property">
        <value name="value">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
    </category>

    <category name="Variables" colour="330">
    <category name="List Variables" id="catVariables" custom="VARIABLE"></category>
    <category  name="Set Variable">
    <block type="set_variable_type"></block>
    </category>
    </category>
    <category name="Functions" id="catFunctions" custom="PROCEDURE" colour="290"></category>

    <sep></sep>

        <category name="Text" id="catText" colour="160">
      <block type="text"></block>
      <block type="text_join"></block>
      <block type="text_append">
        <value name="TEXT">
          <shadow type="text"></shadow>
        </value>
      </block>
      <block type="text_length">
        <value name="VALUE">
          <shadow type="text">
            <field name="TEXT">abc</field>
          </shadow>
        </value>
      </block>
      <block type="text_isEmpty">
        <value name="VALUE">
          <shadow type="text">
            <field name="TEXT"></field>
          </shadow>
        </value>
      </block>
      <block type="text_indexOf">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR">text</field>
          </block>
        </value>
        <value name="FIND">
          <shadow type="text">
            <field name="TEXT">abc</field>
          </shadow>
        </value>
      </block>
      <block type="text_charAt">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR">text</field>
          </block>
        </value>
      </block>
      <block type="text_getSubstring">
        <value name="STRING">
          <block type="variables_get">
            <field name="VAR">text</field>
          </block>
        </value>
      </block>
      <block type="text_changeCase">
        <value name="TEXT">
          <shadow type="text">
            <field name="TEXT">abc</field>
          </shadow>
        </value>
      </block>
      <block type="text_trim">
        <value name="TEXT">
          <shadow type="text">
            <field name="TEXT">abc</field>
          </shadow>
        </value>
      </block>
      <block type="text_print">
        <value name="TEXT">
          <shadow type="text">
            <field name="TEXT">abc</field>
          </shadow>
        </value>
      </block>
      <block type="text_prompt_ext">
        <value name="TEXT">
          <shadow type="text">
            <field name="TEXT">abc</field>
          </shadow>
        </value>
      </block>
    </category>  


    <category name="Logic" id="catLogic" colour="210">
      <block type="controls_if"></block>
      <block type="logic_compare"></block>
      <block type="logic_operation"></block>
      <block type="logic_negate"></block>
      <block type="logic_boolean"></block>
      <block type="logic_null"></block>
      <block type="logic_ternary"></block>
    </category>
    <category name="Math" id="catMath" colour="230">
      <block type="math_number"></block>
      <block type="math_arithmetic">
        <value name="A">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
        <value name="B">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
      <block type="math_single">
        <value name="NUM">
          <shadow type="math_number">
            <field name="NUM">9</field>
          </shadow>
        </value>
      </block>
      <block type="math_trig">
        <value name="NUM">
          <shadow type="math_number">
            <field name="NUM">45</field>
          </shadow>
        </value>
      </block>
      <block type="math_constant"></block>
      <block type="math_number_property">
        <value name="NUMBER_TO_CHECK">
          <shadow type="math_number">
            <field name="NUM">0</field>
          </shadow>
        </value>
      </block>
      <block type="math_change">
        <value name="DELTA">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
      <block type="math_round">
        <value name="NUM">
          <shadow type="math_number">
            <field name="NUM">3.1</field>
          </shadow>
        </value>
      </block>
      <block type="math_on_list"></block>
      <block type="math_modulo">
        <value name="DIVIDEND">
          <shadow type="math_number">
            <field name="NUM">64</field>
          </shadow>
        </value>
        <value name="DIVISOR">
          <shadow type="math_number">
            <field name="NUM">10</field>
          </shadow>
        </value>
      </block>
      <block type="math_constrain">
        <value name="VALUE">
          <shadow type="math_number">
            <field name="NUM">50</field>
          </shadow>
        </value>
        <value name="LOW">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
        <value name="HIGH">
          <shadow type="math_number">
            <field name="NUM">100</field>
          </shadow>
        </value>
      </block>
      <block type="math_random_int">
        <value name="FROM">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
        <value name="TO">
          <shadow type="math_number">
            <field name="NUM">100</field>
          </shadow>
        </value>
      </block>
      <block type="math_random_float"></block>
      <block type="math_atan2">
        <value name="Y">
          <shadow type="math_number">
            <field name="NUM">0</field>
          </shadow>
        </value>
        <value name="X">
          <shadow type="math_number">
            <field name="NUM">0</field>
          </shadow>
        </value>
      </block>
      <block type="math_randomseed">
        <value name="SEED">
          <shadow type="math_number">
            <field name="NUM">0</field>
          </shadow>
        </value>
      </block>
    </category>
    <category name="Loops" id="catLoops" colour="120">
      <block type="controls_repeat_ext">
        <value name="TIMES">
          <shadow type="math_number">
            <field name="NUM">10</field>
          </shadow>
        </value>
      </block>
      <block type="controls_whileUntil"></block>
      <block type="repeat_until" namae="repeat_until">
        <value name="CONDITION">
        <shadow type="logic_boolean">
            <field name="BOOL">FALSE</field>
          </shadow>
        </value>
      </block>
      <block type="controls_for">
        <value name="FROM">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
        <value name="TO">
          <shadow type="math_number">
            <field name="NUM">10</field>
          </shadow>
        </value>
        <value name="BY">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
      <block type="controls_forEach"></block>
      <block type="controls_flow_statements"></block>
    </category>

    <category name="List" id="catLists" colour="260">
      <block type="lists_create_with">
        <mutation items="0"></mutation>
      </block>
      <block type="lists_create_with"></block>
      <block type="lists_repeat">
        <value name="NUM">
          <shadow type="math_number">
            <field name="NUM">5</field>
          </shadow>
        </value>
      </block>
      <block type="lists_length"></block>
      <block type="lists_isEmpty"></block>
      <block type="lists_indexOf">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR">list</field>
          </block>
        </value>
      </block>
      <block type="lists_getIndex">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR">list</field>
          </block>
        </value>
      </block>
      <block type="lists_setIndex">
        <value name="LIST">
          <block type="variables_get">
            <field name="VAR">list</field>
          </block>
        </value>
      </block>
      <block type="lists_getSublist">
        <value name="LIST">
          <block type="variables_get">
            <field name="VAR">list</field>
          </block>
        </value>
      </block>
      <block type="lists_split">
        <value name="DELIM">
          <shadow type="text">
            <field name="TEXT">,</field>
          </shadow>
        </value>
      </block>
    </category>
    <category name="Objects" colour="210" id="objects-category">
      <block type="set_object_property"></block>
      <block type="get_object_property"></block>
      <block type="change_object_property">
        <value name="value">
          <shadow type="math_number">
            <field name="NUM">1</field>
          </shadow>
        </value>
      </block>
    </category>
    </xml>
`
