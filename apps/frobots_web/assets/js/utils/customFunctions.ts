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
  luaGenerator['frobot'] = function (block) {
    var code = 'return function(state, ...)\n end\n'
    var nestedBlock = block.getInputTargetBlock('nested_blocks')
    if (nestedBlock) {
      var code_nested = luaGenerator.blockToCode(nestedBlock)
      let code_new = Array.isArray(code_nested) ? code_nested[0] : code_nested
      code_new = luaGenerator.prefixLines(code_new, '\t')
      code = code
        .split('\n')
        .filter((str) => str.length >= 1)
        .join(`\n${code_new}`)
    }
    return code
  }

  // Damage function code

  Blockly.Blocks['damage'] = {
    init: function () {
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setOutput(true, null)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.appendDummyInput().appendField('Damage')
    },
  }
  luaGenerator['damage'] = function (block) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    var code = luaGenerator.blockToCode(inputBlock)
    code += 'damage()\n'
    return code
  }

  Blockly.Blocks['speed'] = {
    init: function () {
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setOutput(true, null)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.appendDummyInput().appendField('Speed')
    },
  }
  luaGenerator['speed'] = function (block) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    var code = luaGenerator.blockToCode(inputBlock)
    code += 'speed()\n'
    return code
  }

  Blockly.Blocks['drive'] = {
    init: function () {
      this.appendDummyInput().appendField('Drive')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('speed').setCheck(null).appendField('speed')
      this.setOutput(true, null)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['drive'] = function (block) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const speed =
      luaGenerator.valueToCode(block, 'speed', luaGenerator.ORDER_NONE) || 0
    var code = luaGenerator.blockToCode(inputBlock)
    code += `drive(${degree},${speed})\n`
    return code
  }

  Blockly.Blocks['cannon'] = {
    init: function () {
      this.appendDummyInput().appendField('Cannon')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('range').setCheck(null).appendField('range')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['cannon'] = function (block) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const range =
      luaGenerator.valueToCode(block, 'range', luaGenerator.ORDER_NONE) || 0
    var code = luaGenerator.blockToCode(inputBlock)
    code += `cannon(${degree},${range})\n`
    return code
  }

  Blockly.Blocks['scan'] = {
    init: function () {
      this.appendDummyInput().appendField('Scan')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('resolution')
        .setCheck(null)
        .appendField('resolution')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['scan'] = function (block) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const resolution =
      luaGenerator.valueToCode(block, 'resolution', luaGenerator.ORDER_NONE) ||
      0
    var code = luaGenerator.blockToCode(inputBlock)
    code += `scan(${degree},${resolution})\n`
    return code
  }

  Blockly.Blocks['xlocation'] = {
    init: function () {
      this.setOutput(true, 'String')
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.appendDummyInput().appendField('X Location')
    },
  }
  luaGenerator['xlocation'] = function (block) {
    var inputBlock = block.getInputTargetBlock()
    var code = luaGenerator.blockToCode(inputBlock)
    code += 'loc_x()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['ylocation'] = {
    init: function () {
      this.setOutput(true, 'String') // Change output to statement block
      this.setColour(230)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.appendDummyInput().appendField('Y Location')
    },
  }
  luaGenerator['ylocation'] = function (block) {
    var inputBlock = block.getInputTargetBlock()
    var code = luaGenerator.blockToCode(inputBlock)
    code += 'loc_y()\n'
    return [code, luaGenerator.ORDER_NONE]
  }
}
