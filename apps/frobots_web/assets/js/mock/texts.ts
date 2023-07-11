export const AttentionHostLobbyPromptTitle = 'Attention Host'
export const AttentionHostLobbyPromptDescription =
  'Vacant slots are available for the match. Invite players to fill the remaining slots and start the game. Press Start if you prefer to proceed with the current number of players.'
export const EquipmentDetachPromptTitle = (equipmentClass: string) =>
  `Attention: You are about to detach a ${equipmentClass}`
export const EquipmentDetachPromptDescription = (equipmentClass: string) =>
  `Once detached, the currently chosen ${equipmentClass} slot will become vacant. To enable the frobot’s battle functionality, kindly connect an alternative ${equipmentClass} to the slot. Would you like to proceed?`
export const BrainCodeCopyPromptDescription =
  'The current brain code will be overwritten by the lua code in the Block Editor, are you sure?'
export const SaveBrainCodePromptDescription =
  'Please note that the your existing brain code as displayed on the brain code tab will be saved. Any modification done on the brain code tab without using blockly will cause blockly editor and brain code editor to be out of sync. Do you wish to proceed ?'
export const CreateFrobotBrainCodeCopyPromptDescription =
  'The current brain code will be overwritten by the lua code in the Block Editor, are you sure?'
export const SaveBlockCodePromptDescription =
  'Saving the block code does not sync the code over to the brain code, you must click “Sync” to do that. Do you wish to save blockly code without syncing ?'
