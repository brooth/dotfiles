
import re
from .base import Base

from deoplete.logger import getLogger
from deoplete.util import parse_buffer_pattern

logger = getLogger('changes')


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'changes'
        self.mark = '[~]'
        self.rank = 800

    def gather_candidates(self, context):
        # grab ':changes' command output
        self.vim.command('exec "redir => g:deoplete_recent_changes"')
        self.vim.command('silent! changes')
        self.vim.command('redir END')

        p = re.compile('[\s\d]+')
        changes = self.vim.eval('g:deoplete_recent_changes').split('\n')
        lines = set()
        for change in changes:
            m = p.search(change)
            if m:
                line = change[m.span()[1]:]
                if line and line != '-invalid-':
                    lines.add(line)

        candidates = parse_buffer_pattern(lines,
                                     context['keyword_patterns'],
                                     context['complete_str'])
        return [{'word': x} for x in candidates]
