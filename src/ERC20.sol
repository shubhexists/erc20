// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

interface IERC20 {
    event Transfer(
      address indexed from, 
      address indexed to, 
      uint256 value
    );

    event Approval(
        address indexed owner, 
        address indexed spender, 
        uint256 value
    );

  function totalSupply() external view returns(uint256);
  function balanceOf(address account) external view returns(uint256);
  function transfer(address to, uint256 value) external returns(bool);
  function allowance(address owner, address spender) external view returns(uint256);
  function approve(address spender, uint256 value) external returns(bool);
  function transferFrom(address from, address to ,uint256 value) external returns(bool);
}

interface IERC20Metadata {
  function name() external view returns(string memory);
  function symbol() external view returns (string memory);
  function decimals() external view returns (uint8);
}

interface IERC20Errors {
  error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
  error ERC20InvalidSender(address sender);
  error ERC20InvalidReceiver(address reciever);
  error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
  error ERC20InvalidApprover(address approver);
  error ERC20InvalidSpender(address spender);
}

abstract contract ERC20 is IERC20, IERC20Metadata, IERC20Errors {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    mapping(address account => uint256) private balances;
    mapping(address account => mapping(address spender => uint256)) private _allowance;

    constructor(string memory _n,string memory _s,uint8 _d) {
        _name = _n;
        _symbol = _s;
        _decimals = _d;
    }

    modifier checkAllowance(address approver, address from, uint256 _balanceToDeduct) {
      require(_allowance[approver][from] >= _balanceToDeduct, ERC20InsufficientAllowance(from, _allowance[approver][from], _balanceToDeduct));
      _;
    }
    

    modifier invalidApprover(address approver) {
        require(approver != address(0), ERC20InvalidApprover(approver));
      _;
    }

    modifier invalidSpender(address spender) {
        require(spender != address(0), ERC20InvalidSpender(spender));
      _;
    }

    modifier checkBalanceBeforeDeduction(address from, uint256 _balanceToDeduct) {
        require(balances[from] >= _balanceToDeduct, ERC20InsufficientBalance(from, balances[from], _balanceToDeduct));
      _;
    }

    modifier invalidSender(address sender) {
        require(sender != address(0), ERC20InvalidSender(sender));
      _;
    }

    modifier invalidReceiver(address receiver) {
        require(receiver != address(0), ERC20InvalidReceiver(receiver));
      _;
    }

    function name() external virtual view returns(string memory) {
        return _name;
    }

    function symbol() external virtual view returns(string memory) {
        return _symbol;
    }
    
    function decimals() external virtual view returns(uint8) {
        return _decimals;
    }

    function totalSupply() external view returns(uint256) {
      return _totalSupply;
    }

    function balanceOf(address account) external virtual view returns(uint256){
      return balances[account];
    }

    function transfer(address to, uint256 value) external virtual returns(bool) {
      address sender = msg.sender;
      _deductToken(sender, value);
      _addToken(to, value);

      emit Transfer(sender, to, value);
      return true;
    }

    function allowance(address owner, address spender) external virtual view returns(uint256) {
      return _allowance[owner][spender];
    }

    function approve(address spender, uint256 value) external virtual returns(bool) {
      address _personApproving = msg.sender;
      _addAllowance(spender, _personApproving, value);

      emit Approval(_personApproving, spender, value);
      return true;
    }

    function transferFrom(address from, address to ,uint256 value) external virtual returns(bool) {
      address spender = msg.sender;
      _deductAllowance(spender, from, value);
      _deductToken(from, value);
      _addToken(to, value);
      
      emit Transfer(from, to, value);
      return true;
    }

    function _addAllowance(address from, address approver, uint256 value) internal invalidApprover(approver) invalidSpender(from) {
      unchecked {
       _allowance[approver][from] += value;
      }
    }

    function _deductAllowance(address from, address approver, uint256 value) internal checkAllowance(approver, from, value) invalidApprover(approver) invalidSpender(from) {
      unchecked {
         _allowance[approver][from] -= value; 
      }
    }

    function _deductToken(address from, uint256 amount) internal invalidSender(from) checkBalanceBeforeDeduction(from, amount) {
      unchecked {
        balances[from] -= amount;
      }
    }

    function _addToken(address to, uint256 amount) internal invalidReceiver(to) {
      unchecked {
        balances[to] += amount;
      }
    }

    function _mint(address to, uint256 amount) internal invalidReceiver(to) {
     unchecked {
      _totalSupply += amount;
      balances[to] += amount;
     }
    }

    function _burn(address from, uint256 amount) internal checkBalanceBeforeDeduction(from, amount) invalidSender(from) {
     unchecked {
      _totalSupply -= amount;
      balances[from] -= amount;
     }
    }
}
