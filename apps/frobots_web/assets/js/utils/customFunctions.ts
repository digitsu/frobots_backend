import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'

export default () => {
  // Create Frobot code
  Blockly.Blocks['frobot'] = {
    init: function () {
      this.appendDummyInput().appendField('Create Frobot')
      this.appendStatementInput('nested_blocks').setCheck(null)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setTooltip('frobot')
      this.setHelpUrl('')
    },
  }
  luaGenerator['frobot'] = function (block: any) {
    let code_new = '';
    var nestedBlock = block.getInputTargetBlock('nested_blocks')
    if (nestedBlock) {
      var code_nested = luaGenerator.blockToCode(nestedBlock)
      code_new = Array.isArray(code_nested) ? code_nested[0] : code_nested
      code_new = luaGenerator.prefixLines(code_new, '\n\t')
    }

    return `return function(state, ...)\n\tstate = state or {}${code_new ? `${code_new}` : `\n`}\treturn state\nend\n`
  }

  // Custom Return code
  Blockly.Blocks['custom_return'] = {
    init: function () {
      this.appendValueInput('return').setCheck(null).appendField('return')
      this.setPreviousStatement(true, null)
      this.setColour(230)
      this.setTooltip('Return any value')
      this.setHelpUrl('')
    },
  }
  luaGenerator['custom_return'] = function (block: any) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    const result =
      luaGenerator.valueToCode(block, 'return', luaGenerator.ORDER_NONE) || 0
    var code = luaGenerator.blockToCode(inputBlock)
    code += `return ${result}\n`
    return code
  }

  // Damage function code
  Blockly.Blocks['damage'] = {
    init: function () {
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setOutput(true, null)
      this.appendDummyInput().appendField('Damage')
    },
  }
  luaGenerator['damage'] = function () {
    var code = 'damage()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['speed'] = {
    init: function () {
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setOutput(true, null)
      this.appendDummyInput().appendField('Speed')
    },
  }
  luaGenerator['speed'] = function () {
    var code = 'speed()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['drive'] = {
    init: function () {
      this.appendDummyInput().appendField('Drive')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('speed').setCheck(null).appendField('speed')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['drive'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const speed =
      luaGenerator.valueToCode(block, 'speed', luaGenerator.ORDER_NONE) || 0
    var code = `drive(${degree},${speed})\n`
    return code
  }

  Blockly.Blocks['cannon'] = {
    init: function () {
      this.appendDummyInput().appendField('Cannon')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('range').setCheck(null).appendField('range')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['cannon'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const range =
      luaGenerator.valueToCode(block, 'range', luaGenerator.ORDER_NONE) || 0
    var code = `cannon(${degree},${range})\n`
    return code
  }

  Blockly.Blocks['scan'] = {
    init: function () {
      this.appendDummyInput().appendField('Scan')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('resolution')
        .setCheck(null)
        .appendField('resolution')
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['scan'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const resolution =
      luaGenerator.valueToCode(block, 'resolution', luaGenerator.ORDER_NONE) || 0
    var code = `scan(${degree},${resolution})`
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['xlocation'] = {
    init: function () {
      this.setOutput(true, 'String')
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.appendDummyInput().appendField('X Location')
    },
  }
  luaGenerator['xlocation'] = function () {
    var code = 'loc_x()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['ylocation'] = {
    init: function () {
      this.setOutput(true, 'String')
      this.setColour(230)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.appendDummyInput().appendField('Y Location')
    },
  }
  luaGenerator['ylocation'] = function () {
    var code = 'loc_y()'
    return [code, luaGenerator.ORDER_NONE]
  }

  /// multi
  Blockly.Blocks['table_create'] = {
    init: function () {
      this.appendDummyInput()
        .appendField("Create Table");
      this.setOutput(true, "Table");
      this.setColour(260);
      this.setTooltip("Creates a new table");
      this.setHelpUrl("");
    }
  }
  luaGenerator['table_create'] = function () {
    var code = '{}';
    return [code, luaGenerator.ORDER_ATOMIC];
  }

  Blockly.Blocks['insert_table_value'] = {
    init: function () {
      this.appendValueInput("TABLE")
        .setCheck("Table")
        .appendField("insert value into table");
      this.appendValueInput("KEY")
        .setCheck(null)
        .appendField("at key");
      this.appendValueInput("VALUE")
        .setCheck(null)
        .appendField("with value");
      this.setPreviousStatement(true, null);
      this.setNextStatement(true, null);
      this.setColour(260);
      this.setTooltip("Inserts a value into a table using a key");
      this.setHelpUrl("");
    }
  }
  luaGenerator['insert_table_value'] = function (block: any) {
    var table = luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) || '{}';
    var key = luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""';
    var value = luaGenerator.valueToCode(block, 'VALUE', luaGenerator.ORDER_ATOMIC) || '""';
    var code = table + '[' + key + '] = ' + value + '\n';
    return code;
  }

  Blockly.Blocks['get_table_value'] = {
    init: function () {
      this.appendValueInput("TABLE")
        .setCheck("Table")
        .appendField("get value from table");
      this.appendValueInput("KEY")
        .setCheck(null)
        .appendField("by key");
      this.setOutput(true, null);
      this.setColour(260);
      this.setTooltip("Retrieves the value from a table using a key");
      this.setHelpUrl("");
    }
  }
  luaGenerator['get_table_value'] = function (block: any) {
    var table = luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) || '{}';
    var key = luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""';
    var code = table + '[' + key + ']';
    return [code, luaGenerator.ORDER_ATOMIC];
  };


  Blockly.Blocks['set_table_value'] = {
    init: function () {
      this.appendValueInput("TABLE")
        .setCheck("Table")
        .appendField("set value in table");
      this.appendValueInput("KEY")
        .setCheck(null)
        .appendField("at key");
      this.appendValueInput("VALUE")
        .setCheck(null)
        .appendField("to");
      this.setPreviousStatement(true, null);
      this.setNextStatement(true, null);
      this.setColour(260);
      this.setTooltip("Sets the value of a table at the specified key");
      this.setHelpUrl("");
    }
  }
  luaGenerator['set_table_value'] = function (block: any) {
    var table = luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) || '{}';
    var key = luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""';
    var value = luaGenerator.valueToCode(block, 'VALUE', luaGenerator.ORDER_ATOMIC) || '""';
    var code = table + '[' + key + '] = ' + value + '\n';
    return code;
  };

  Blockly.Blocks['remove_table_value'] = {
    init: function () {
      this.appendValueInput("TABLE")
        .setCheck("Table")
        .appendField("remove value from table");
      this.appendValueInput("KEY")
        .setCheck(null)
        .appendField("at key");
      this.setPreviousStatement(true, null);
      this.setNextStatement(true, null);
      this.setColour(260);
      this.setTooltip("Removes a value from a table at the specified key");
      this.setHelpUrl("");
    }
  }
  luaGenerator['remove_table_value'] = function (block: any) {
    var table = luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) || '{}';
    var key = luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""';
    var code = table + '[' + key + '] = nil\n';
    return code;
  };
}
