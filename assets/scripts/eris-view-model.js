// View Model for Contracts Editing, Testing, and Deployment
function ErisServerViewModel() {
  var self = this;

  // alerts
  self.alerts = ko.observableArray();

  // contract fields
  self.contractInit = ko.observable();
  self.compiledContractInit = ko.observable();

  self.contractBody = ko.observable();
  self.compiledContractBody = ko.observable();

  self.contractEndowment = ko.observable();
  self.contractEndowmentLevels = new TokenLevels;
  self.contractEndowmentLevelSelected = ko.observable(self.contractEndowmentLevels[3]);

  self.contractDeploymentGas = ko.observable('10000');

  self.contractFileName = ko.observable($('#filename').attr('data-filename'));
  self.contractPackageName = ko.observable($('#packagename').attr('data-packname'));

  // ace editor
  self.contractTypeOptions = ko.observableArray(['Serpent', 'Mutan']);
  self.contractType = ko.observable($('#mode').attr('data-editor') || 'Serpent');

  self.themeNames = new Themes;
  // set monokai as default
  self.selectedTheme = ko.observable(self.themeNames[17]);

  // transaction fields
  self.transactionData = ko.observable(' ');
  self.compiledTransactionData = ko.observable();

  self.transactionValue = ko.observable('100');
  self.transactionValueLevels = new TokenLevels;
  self.transactionValueLevelSelected = ko.observable(self.transactionValueLevels[4]);

  self.transactionGas = ko.observable('10000');

  self.transactionRecipient = ko.observable();

  // query fields
  self.balanceAddress = ko.observable();
  self.balanceAmount = ko.observable();

  self.nonceAddress = ko.observable();
  self.nonceCount = ko.observable();

  self.storageAddress = ko.observable();
  self.storagePosition = ko.observable();
  self.storageResult = ko.observable();
  self.storageInput = ko.observable();
  self.storageInputOptions = ko.observableArray(['Address', 'Number']);
  self.storageOutput = ko.observable();
  self.storageOutputOptions = ko.observableArray(['String', 'Number', 'Ether']);

  // package fields
  self.packageToInstall = ko.observable();

  // account keys, again with a check for if we are in a normal browser or alethzero
  if( window.eth ) {
    myAddresses = eth.keys();
    self.myPublicKeyStrings = ko.observableArray([]);

    for (var i = 0; i < myAddresses.length; i++) {
      self.myPublicKeyStrings.push(key.stringOf(key.address(myAddresses[i])));
    };
  } else {
    self.myPublicKeyStrings = [ 'asdf', 'qwer' ];
  };
  self.sendingPublic = ko.observable(self.myPublicKeyStrings[0]);

  // computed elements which need to utilize the u256 format prior to deployment
  self.formattedEndowment = ko.computed(function() {
    level = self.contractEndowmentLevelSelected().multiplier;
    endow = self.contractEndowment();
    ether = new TokenLevels;
    ether = ether[6].multiplier;
    value = ((level * endow) / ether);
    return (value);
  });

  self.formattedTransactionValue = ko.computed(function() {
    level = self.transactionValueLevelSelected().multiplier;
    txVal = self.transactionValue();
    ether = new TokenLevels;
    ether = ether[6].multiplier;
    value = ((level * txVal) / ether);
    return (value);
  });

  if ( window.aceBodyEditor ) {
    self.editorMode = ko.computed(function() {
      if (self.contractType() == 'Serpent') {
        window.aceBodyEditor.getSession().setMode("ace/mode/python");
        window.aceInitEditor.getSession().setMode("ace/mode/python");
      } else {
        window.aceBodyEditor.getSession().setMode("ace/mode/golang");
        window.aceInitEditor.getSession().setMode("ace/mode/golang");
      };
    });

    self.editorTheme = ko.computed(function() {
      window.aceBodyEditor.setTheme("ace/theme/" + self.selectedTheme().fileName);
      window.aceInitEditor.setTheme("ace/theme/" + self.selectedTheme().fileName);
    });
  };

  // --Operations
  // ---Contracts
  // ajax call to sinatra for compiling and return appropriate values
  self.compileContractBody = function() {
    if ( window.aceBodyEditor ){
      self.contractBody(window.aceBodyEditor.getSession().getValue());
      self.contractInit(window.aceInitEditor.getSession().getValue());
    }
    $.ajax('/contracts/compile', {
      data: ko.toJSON({ contractType: self.contractType, contractInit: self.contractInit, contractBody: self.contractBody }),
      type: 'post',
      contentType: 'application/json',
      success: function(result) {
        self.compiledContractInit(result['contractInit']);
        self.compiledContractBody(result['contractBody']);
      }
    });
    $("#editor").slideUp('slow', function() {
      $("#review").removeClass('hidden').slideDown('slow');
    });
    $("#review").slideDown('slow');
  };

  self.editContract = function() {
    $("#review").slideUp('slow', function() {
      $("#editor").slideDown('slow', function() {
        $("#review").addClass('hidden');
      });
    });
  };

  // ajax call to sinatra for testing and return test results
  self.testContract = function(seat) {
    // todo
  };

  // eth call to deploy the contract
  self.deployContract = function() {
    account = self.myPublicKeyStrings.indexOf(self.sendingPublic());
    secret = key.secret(eth.keys()[account]);
    self.contractAddress = (eth.create(
        secret,
        u256.ether(self.formattedEndowment()),
        self.compiledContractBody,
        self.compiledContractInit,
        u256.value(self.contractDeploymentGas()),
        eth.gasPrice()
    ));
    if(self.contractAddress) {
      if (self.contractFileName){
          self.saveContract();
          self.alerts([{'message': 'You have just created a Contract with address of: ' + key.stringOf(self.contractAddress), 'priority': 'info'}]);
      } else {
        self.alerts([{'message': 'You have just created a Contract with address of: ' + key.stringOf(self.contractAddress), 'priority': 'warning'}]);
      }
    }
  };

  self.saveContract = function() {
    if ( window.eth ) {
      self.contractAddress(key.stringOf(self.contractAddress));
    };
    $.ajax('/contracts/save', {
      data: ko.toJSON({
        contractType: self.contractType,
        contractInit: self.contractInit,
        contractBody: self.contractBody,
        contractAddress: self.contractAddress,
        contractFileName: self.contractFileName,
        contractPackageName: self.contractPackageName
      }),
      type: 'post',
      contentType: 'application/json',
      success: function(result) {
        self.alerts([{'message': 'I have saved the contract.', 'priority': 'success'}]);
      }
    });
  };

  // ---Transactions
  self.sendTransaction = function() {
    account = self.myPublicKeyStrings.indexOf(self.sendingPublic());
    secret = key.secret(eth.keys()[account]);
    $.ajax('/transactions/compile_text_data', {
      data: self.transactionData(),
      type: 'post',
      contentType: 'application/text',
      success: function(result) {
        self.compiledTransactionData(result);
      }
    });
    eth.transact(
        secret,
        u256.ether(self.formattedTransactionValue()),
        key.addressOf(self.transactionRecipient()),
        self.transactionData(),
        u256.value(self.transactionGas()),
        eth.gasPrice()
      );
  };

  // ---Queries
  self.queryNonce = function() {
    self.nonceCount(eth.txCountAt(key.addressOf(self.nonceAddress())));
  };

  self.queryBalance = function() {
    self.balanceAmount(u256.ethOf(eth.balanceAt(key.addressOf(self.balanceAddress()))));
  };

  self.queryStorage = function() {
    if(self.storageInput() == 'Address'){
      if(self.storageOutput() == 'String'){
        var output = eth.storageAt(
          key.addressOf(self.storageAddress()),
          u256.fromAddress(key.addressOf(self.storagePosition()))
        );
        output = output.split("").reverse().join("").slice(8,output.length);
      };
      if(self.storageOutput() == 'Number'){
        var output = u256.toValue(eth.storageAt(
          key.addressOf(self.storageAddress()),
          u256.fromAddress(key.addressOf(self.storagePosition()))
        ));
      };
      if(self.storageOutput() == 'Ether'){
        var output = u256.ethOf(eth.storageAt(
            key.addressOf(self.storageAddress()),
            u256.fromAddress(key.addressOf(self.storagePosition()))
        ));
      };
    };
    if(self.storageInput() == 'Number'){
      if(self.storageOutput() == 'String'){
        var output = eth.storageAt(
            key.addressOf(self.storageAddress()),
            u256.value(Number(self.storagePosition()))
        );
        output = output.split("").reverse().join("").slice(8,output.length);
      };
      if(self.storageOutput() == 'Number'){
        var output = u256.toValue(eth.storageAt(
            key.addressOf(self.storageAddress()),
            u256.value(Number(self.storagePosition()))
        ));
      };
      if(self.storageOutput() == 'Ether'){
        var output = u256.ethOf(eth.storageAt(
            key.addressOf(self.storageAddress()),
            u256.value(Number(self.storagePosition()))
        ));
      };
    };
    self.storageResult(output);
  };

  // ---Packages
  self.installPackage = function() {
    $('#library').slideUp('slow');
    $('#install-button').hide();
    $('#install').slideDown('slow', function() {
      $('#install').removeClass('hidden');
    });
  };

  self.installThisPackage = function() {
    $.ajax('/library/install', {
      data: ko.toJSON({ packageToInstall: self.packageToInstall }),
      type: 'post',
      contentType: 'application/json',
      success: function(result) {
        $('#install').slideUp('slow', function() {
          $('#install').addClass('hidden');
          $('#install-button').show();
          $('#library').slideDown('slow');
        });
      }
    });
  };
};

window.eris = new ErisServerViewModel();
ko.applyBindings( eris );