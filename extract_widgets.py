import os

base_dir = r'c:\Users\Meds\Desktop\flutter_projects\stiv\lib\features\diagnostic\presentation\pages\quick_diagnostic_page\quick_diagnostic_flow_page'
widgets_dir = os.path.join(base_dir, 'widgets')
file_path = os.path.join(base_dir, 'diagnostic_flow_page.dart')

if not os.path.exists(widgets_dir):
    os.makedirs(widgets_dir)

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_imports = []
import_block_end = 0

for i, line in enumerate(lines):
    if line.startswith('import '):
        import_block_end = i + 1
        new_import = line.replace('diagnostic_flow_page/widgets', 'quick_diagnostic_page/quick_diagnostic_flow_page/widgets')
        if new_import not in new_imports:
            new_imports.append(new_import)
    elif line.strip() == '':
        if i < 15: # roughly
            if line not in new_imports:
                new_imports.append(line)

# Let's extract Header
header_start, header_end = -1, -1
back_start, back_end = -1, -1
dialog_start, dialog_end = -1, -1
content_start, content_end = -1, -1

for i, line in enumerate(lines):
    if line.startswith('// ─── Header '):
        header_start = i
    elif line.startswith('// ─── Back button '):
        header_end = i
        back_start = i
    elif line.startswith('// ─── Styled Dialog '):
        back_end = i
        dialog_start = i
    elif line.startswith('// ─── Question content '):
        dialog_end = i
        content_start = i

content_end = len(lines)

header_lines = lines[header_start+1:header_end]
back_lines = lines[back_start+1:back_end]
dialog_lines = lines[dialog_start+1:dialog_end]
content_lines = lines[content_start+1:content_end]

def remove_prefix(text_lines, old_name, new_name):
    content = ''.join(text_lines)
    return content.replace(old_name, new_name)

header_content = remove_prefix(header_lines, 'class _FlowHeader', 'class FlowHeader')
back_content = remove_prefix(back_lines, 'class _BackButton', 'class FlowBackButton')
back_content = back_content.replace('_BackButtonState', '_FlowBackButtonState')
dialog_content = remove_prefix(dialog_lines, 'class _StyledDialog', 'class StyledDialog')
content_content = remove_prefix(content_lines, 'class _QuestionContent', 'class QuestionContent')

new_imports.extend([
    "import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/flow_header.dart';\n",
    "import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/flow_back_button.dart';\n",
    "import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/styled_dialog.dart';\n",
    "import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/question_content.dart';\n",
    "\n"
])

with open(os.path.join(widgets_dir, 'flow_header.dart'), 'w', encoding='utf-8') as f:
    f.write("import 'package:flutter/material.dart';\nimport 'package:stiv/core/theme/theme_data.dart';\n" + header_content)

with open(os.path.join(widgets_dir, 'flow_back_button.dart'), 'w', encoding='utf-8') as f:
    f.write("import 'package:flutter/material.dart';\nimport 'package:stiv/core/theme/theme_data.dart';\n" + back_content)

with open(os.path.join(widgets_dir, 'styled_dialog.dart'), 'w', encoding='utf-8') as f:
    f.write("import 'package:flutter/material.dart';\nimport 'package:stiv/core/theme/theme_data.dart';\n" + dialog_content)

with open(os.path.join(widgets_dir, 'question_content.dart'), 'w', encoding='utf-8') as f:
    f.write("import 'package:flutter/material.dart';\nimport 'package:stiv/core/theme/theme_data.dart';\nimport 'package:stiv/features/diagnostic/models/diagnostic_question.dart';\nimport 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/question_option_card.dart';\n" + content_content)

main_content = ''.join(new_imports) + ''.join(lines[import_block_end:header_start])
main_content = main_content.replace('_FlowHeader', 'FlowHeader')
main_content = main_content.replace('_BackButton', 'FlowBackButton')
main_content = main_content.replace('_StyledDialog', 'StyledDialog')
main_content = main_content.replace('_QuestionContent', 'QuestionContent')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(main_content)

print('Success')
