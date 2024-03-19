export default function degToCompass(num) {
    const val = Math.floor((num / 22.5) + 0.5);
    const arr = ["N", "NNO", "NO", "ONO", "O", "OSO", "SO", "SSO", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
    return arr[(val % 16)];
  }