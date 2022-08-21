module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  plugins: [
    'svelte3'
  ],
  extends: 'airbnb-base',
  overrides: [
    {
      files: ['*.svelte'],
      processor: 'svelte3/svelte3'
    }
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
  },
};
