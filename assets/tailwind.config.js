const colors = require("tailwindcss/colors");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  mode: "jit",
  content: [
    "../lib/**/*.ex",
    "../lib/**/*.leex",
    "../lib/**/*.eex",
    "../lib/**/*.heex",
    "./js/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        gray: colors.neutral,
        primary: colors.violet,
        secondary: colors.pink,
        spotify: {
          50: "#edf8f6",
          100: "#d5f8ed",
          200: "#a8f3d4",
          300: "#68ebb6",
          400: "#20dc86",
          500: "#09c858",
          600: "#1db954",
          700: "#0e913b",
          800: "#127237",
          900: "#115c30",
        },
      },
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/line-clamp")],
};
