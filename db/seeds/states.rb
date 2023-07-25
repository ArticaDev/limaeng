states_data = [
    { name: 'ARACAJU', abbreviation: 'SE', low_price_per_meter: 2.09684, medium_price_per_meter: 2.12728, high_price_per_meter: 2.44244 },
    { name: 'BELEM', abbreviation: 'PA', low_price_per_meter: 2.17241, medium_price_per_meter: 2.22728, high_price_per_meter: 2.49922 },
    { name: 'BELO HORIZONTE', abbreviation: 'MG', low_price_per_meter: 2.26829, medium_price_per_meter: 2.23609, high_price_per_meter: 2.68288 },
    { name: 'BOA VISTA', abbreviation: 'RR', low_price_per_meter: 2.21628, medium_price_per_meter: 2.21628, high_price_per_meter: 2.40075 },
    { name: 'BRASILIA', abbreviation: 'DF', low_price_per_meter: 2.28671, medium_price_per_meter: 2.30420, high_price_per_meter: 2.67007 },
    { name: 'CAMPO GRANDE', abbreviation: 'MS', low_price_per_meter: 2.12012, medium_price_per_meter: 2.12012, high_price_per_meter: 2.44869 },
    { name: 'CUIABA', abbreviation: 'MG', low_price_per_meter: 2.18223, medium_price_per_meter: 2.23937, high_price_per_meter: 2.46400 },
    { name: 'CURITIBA', abbreviation: 'PR', low_price_per_meter: 2.35446, medium_price_per_meter: 2.35446, high_price_per_meter: 2.80518 },
    { name: 'FLORIANOPOLIS', abbreviation: 'SC', low_price_per_meter: 2.52887, medium_price_per_meter: 2.52887, high_price_per_meter: 3.13183 },
    { name: 'FORTALEZA', abbreviation: 'CE', low_price_per_meter: 2.13169, medium_price_per_meter: 2.13992, high_price_per_meter: 2.46496 },
    { name: 'GOIANIA', abbreviation: 'GO', low_price_per_meter: 2.14262, medium_price_per_meter: 2.15870, high_price_per_meter: 2.47078 },
    { name: 'JOAO PESSOA', abbreviation: 'PB', low_price_per_meter: 1.99337, medium_price_per_meter: 1.99337, high_price_per_meter: 2.26535 },
    { name: 'MACAPA', abbreviation: 'AP', low_price_per_meter: 2.06662, medium_price_per_meter: 2.14332, high_price_per_meter: 2.34048 },
    { name: 'MACEIO', abbreviation: 'AL', low_price_per_meter: 1.96958, medium_price_per_meter: 2.02661, high_price_per_meter: 2.25447 },
    { name: 'MANAUS', abbreviation: 'AM', low_price_per_meter: 2.28450, medium_price_per_meter: 2.34274, high_price_per_meter: 2.58158 },
    { name: 'NATAL', abbreviation: 'RN', low_price_per_meter: 2.01817, medium_price_per_meter: 2.07182, high_price_per_meter: 2.36004 },
    { name: 'PALMAS', abbreviation: 'TO', low_price_per_meter: 2.07921, medium_price_per_meter: 2.11054, high_price_per_meter: 2.35222 },
    { name: 'PORTO ALEGRE', abbreviation: 'RS', low_price_per_meter: 2.10247, medium_price_per_meter: 2.16954, high_price_per_meter: 2.34219 },
    { name: 'PORTO VELHO', abbreviation: 'RO', low_price_per_meter: 2.33694, medium_price_per_meter: 2.34144, high_price_per_meter: 2.55428 },
    { name: 'RECIFE', abbreviation: 'PE', low_price_per_meter: 2.17278, medium_price_per_meter: 2.18857, high_price_per_meter: 2.52019 },
    { name: 'RIO BRANCO', abbreviation: 'AC', low_price_per_meter: 2.36212, medium_price_per_meter: 2.40895, high_price_per_meter: 2.64948 },
    { name: 'RIO DE JANEIRO', abbreviation: 'RJ', low_price_per_meter: 2.49467, medium_price_per_meter: 2.49467, high_price_per_meter: 2.93725 },
    { name: 'SALVADOR', abbreviation: 'BA', low_price_per_meter: 2.13745, medium_price_per_meter: 2.18228, high_price_per_meter: 2.50973 },
    { name: 'SAO LUIS', abbreviation: 'MA', low_price_per_meter: 2.11206, medium_price_per_meter: 2.11999, high_price_per_meter: 2.43634 },
    { name: 'SAO PAULO', abbreviation: 'SP', low_price_per_meter: 2.33816, medium_price_per_meter: 2.34172, high_price_per_meter: 2.70800 },
    { name: 'TERESINA', abbreviation: 'PI', low_price_per_meter: 1.97030, medium_price_per_meter: 2.00735, high_price_per_meter: 2.17330 },
    { name: 'VITORIA', abbreviation: 'ES', low_price_per_meter: 2.13676, medium_price_per_meter: 2.20794, high_price_per_meter: 2.54538 },
  ]
  
  states_data.each do |state_data|
    State.create!(
      name: state_data[:name],
      abbreviation: state_data[:abbreviation],
      low_price_per_meter: state_data[:low_price_per_meter],
      medium_price_per_meter: state_data[:medium_price_per_meter],
      high_price_per_meter: state_data[:high_price_per_meter]
    )
  end
  