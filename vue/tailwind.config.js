/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx,vue}",
  ],
  theme: {
    extend: {
      colors: {
        'blue': 'rgb(29, 155, 240)',
        'blue-hover': 'rgb(26, 140, 216)',
        'gray': 'rgba(15, 20, 25, 0.1)',
        'gray-hover': 'rgba(231, 233, 234, 0.1)',
      },
    },
  },
  plugins: [],
}
