import numpy as np
import matplotlib.pyplot as plt
import sys

# Параметры, которые можно менять
HEADER_SIZE = 64  # Размер заголовка (подбирается экспериментально)
DATA_TYPE = np.int16  # Формат данных (int16, int32, float32)
SAMPLES_TO_PLOT = 5000  # Количество отсчетов для отображения

def main():
    if len(sys.argv) < 2:
        print("Использование: python plot_ecg.py <filename>")
        return
    
    filename = sys.argv[1]
    
    try:
        # Чтение бинарного файла
        with open(filename, 'rb') as f:
            raw_data = f.read()
        
        # Пропуск заголовка и преобразование в массив чисел
        ecg_data = raw_data[HEADER_SIZE:]
        ecg_signal = np.frombuffer(ecg_data, dtype=DATA_TYPE)
        
        # Если данных меньше, чем нужно для отображения
        if len(ecg_signal) < SAMPLES_TO_PLOT:
            SAMPLES = len(ecg_signal)
        else:
            SAMPLES = SAMPLES_TO_PLOT
        
        # Нормализация сигнала
        ecg_signal = ecg_signal - np.mean(ecg_signal[:SAMPLES])
        
        # Построение графика
        plt.figure(figsize=(12, 6))
        plt.plot(ecg_signal[:SAMPLES], linewidth=0.8)
        plt.title(f"ECG Signal from {filename}")
        plt.xlabel("Samples")
        plt.ylabel("Amplitude")
        plt.grid(True, linestyle='--', alpha=0.7)
        
        # Сохранение и отображение
        plt.savefig('ecg_plot.png', dpi=300, bbox_inches='tight')
        print("График сохранен как ecg_plot.png")
        plt.show()
        
    except Exception as e:
        print(f"Ошибка: {e}")

if __name__ == "__main__":
    main()
