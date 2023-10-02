const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        header: ['Poiret One, sans-serif'],
        raleway: ['Raleway'],
        poppins: ['Poppins', 'sans-serif'],
        delaGothicOne: ['Dela Gothic One'],
        poiretOne: ['Poiret One'],
        righteous: ['Righteous'],
        // header: ['Gemunu Libre'],
      },
      colors: {
        ...defaultTheme.colors,
        blue: '#1fb6ff',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    // require('flowbite/plugin'),
  ],
};
