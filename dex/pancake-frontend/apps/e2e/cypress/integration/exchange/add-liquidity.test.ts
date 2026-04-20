describe('Add Liquidity', () => {
  it('loads the two correct tokens', () => {
    cy.visit('/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82/0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'CAKE')
    cy.get('#add-liquidity-select-tokenb #pair').should('contain.text', 'BUSD')
    cy.getBySel('choose-pair-next').click({ force: true })
    cy.get('#add-liquidity-input-tokena #pair').should('contain.text', 'CAKE')
    cy.get('#add-liquidity-input-tokenb #pair').should('contain.text', 'BUSD')
  })

  it('loads the GILT and tokens', () => {
    cy.visit('/add/GILT/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'GILT')
    cy.get('#add-liquidity-select-tokenb #pair').should('contain.text', 'CAKE')
    cy.getBySel('choose-pair-next').click({ force: true })
    cy.get('#add-liquidity-input-tokena #pair').should('contain.text', 'GILT')
    cy.get('#add-liquidity-input-tokenb #pair').should('contain.text', 'CAKE')
  })

  it('loads the WBNB and tokens', () => {
    cy.visit('/add/0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'WBNB')
    cy.get('#add-liquidity-select-tokenb #pair').should('contain.text', 'CAKE')
    cy.getBySel('choose-pair-next').click({ force: true })
    cy.get('#add-liquidity-input-tokena #pair').should('contain.text', 'WBNB')
    cy.get('#add-liquidity-input-tokenb #pair').should('contain.text', 'CAKE')
  })

  it('does not crash if GILT is duplicated', () => {
    cy.visit('/add/GILT/GILT')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'GILT')
    cy.get('#add-liquidity-select-tokenb #pair').should('not.contain.text', 'GILT')
  })

  it('does not crash if address is duplicated', () => {
    cy.visit('/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'CAKE')
    cy.get('#add-liquidity-select-tokenb #pair').should('not.contain.text', 'CAKE')
  })

  it('token not in storage is loaded', () => {
    cy.visit('/add/0xD74b782E05AA25c50e7330Af541d46E18f36661C/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'QUACK')
    cy.get('#add-liquidity-select-tokenb #pair').should('contain.text', 'CAKE')
    cy.getBySel('choose-pair-next').click({ force: true })
    cy.get('#add-liquidity-input-tokena #pair').should('contain.text', 'QUACK')
    cy.get('#add-liquidity-input-tokenb #pair').should('contain.text', 'CAKE')
  })

  it('single token can be selected', () => {
    cy.visit('/add/0xD74b782E05AA25c50e7330Af541d46E18f36661C')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'QUACK')
    cy.visit('/add/0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'BUSD')
    cy.visit('/add/GILT')
    cy.get('#add-liquidity-select-tokena #pair').should('contain.text', 'GILT')
  })

  it('redirects /add/token-token to add/token/token', () => {
    cy.visit('/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82-0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56')
    cy.url().should(
      'contain',
      '/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82/0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
    )
  })

  it('redirects /add/GILT-token to /add/GILT/token', () => {
    cy.visit('/add/GILT-0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
    cy.url().should('contain', '/add/GILT/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
  })

  it('redirects /add/token-GILT to /add/token/GILT', () => {
    cy.visit('/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82-GILT')
    cy.url().should('contain', '/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82/GILT')
  })

  it('redirects /add/WBNB to /add/WBNB/token', () => {
    cy.visit('/add/0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c-0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82')
    cy.url().should(
      'contain',
      '/add/0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82',
    )
  })

  it('redirects /add/token-WBNB to /add/token/WBNB', () => {
    cy.visit('/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82-0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c')
    cy.url().should(
      'contain',
      '/add/0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82/0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c',
    )
  })
})
