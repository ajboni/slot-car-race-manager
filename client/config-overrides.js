const {
  addDecoratorsLegacy,
  override,
  disableEsLint,
  removeModuleScopePlugin
} = require("customize-cra");


module.exports = override(
    removeModuleScopePlugin(),
    addDecoratorsLegacy(),
    disableEsLint(),    
    
);    
