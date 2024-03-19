export default function getBackgroundClass(weatherCondition) {
    if (weatherCondition.includes('clear')) return 'clear';
    if (weatherCondition.includes('cloud')) return 'cloudy';
    if (weatherCondition.includes('rain') || weatherCondition.includes('drizzle')) return 'rainy';
    if (weatherCondition.includes('storm')) return 'stormy';
    if (weatherCondition.includes('fog') || weatherCondition.includes('mist') || weatherCondition.includes('haze')) return 'fogy';
    if (weatherCondition.includes('snow')) return 'snowy';
    if (weatherCondition.includes('smoke')) return 'smokey';
    else
    return 'default';
  }