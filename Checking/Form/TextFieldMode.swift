//
//  TextFieldMode.swift
//  Checking
//
//  Created by Краснокутский Владислав on 05.08.2022.
//

import UIKit

public enum TextFieldMode {
	/// Режим по умолчанию
	case none
	/// Только для чтения, справа появляется кнопка *Скопировать текст*
	case readOnly
	/// Справа появляется кнопка *Удалить текст*
	case clearMode
	/// Справа появляется кнопка *Показать/скрыть текст*
	case secureMode
}
